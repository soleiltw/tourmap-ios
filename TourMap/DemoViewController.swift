//
//  DemoViewController.swift
//  TourMap
//
//  Created by Edward Chiang on 11/14/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit
import BFDragGestureRecognizer
import GestureRecognizerClosures
import Parse
import Font_Awesome_Swift
import XCGLogger

struct BlurEffect {
    static let transparentAlpha : CGFloat = 0.6
}

struct Demo {
    static let defaultEventObjectId : String = "UdCDGMudrh"
}

/// The canvas demo class to present image and gesture.
class DemoViewController: UIViewController {
    
    /// Add a blur view on map view while user interact with.
    var mapViewBlurView: UIView?
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// The canvas need to transform scale.
    var painter : Painter?
    
    var mapImageView: UIImageView!
    
    /// Hold for drag recognizer
    var startCenter: CGPoint!
    
    var eventObject : Event?
    
    var stickerObjects = [Graphical]()
    
    var eventObjectId : String = Demo.defaultEventObjectId
    
    override func awakeFromNib() {
        painter = Painter.init(current: 0.6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XCGLogger.defaultInstance().debug("UIScreen.mainScreen().bounds = \(UIScreen.mainScreen().bounds)")
        
        // Init map image view
        self.mapImageView = UIImageView()
        self.mapImageView.userInteractionEnabled = true
        self.mapImageView.frame = CGRectZero
        self.scrollView.addSubview(mapImageView)
        
        // Query from parse
        self.queryEvent()
        
        // Add pinch gesture
        self.mapImageView.onPinch { (pinchGestureRecognizer) -> Void in
            // TODO: Support pinch for user zoom in / out
        }
        
        // Setup dimiss button
        let settingsButton = UIButton()
        settingsButton.setFAIcon(FAType.FAGear, iconSize: 36, forState: .Normal)
        settingsButton.sizeToFit()
        settingsButton.frame = CGRectMake(0, 0, settingsButton.frame.width, settingsButton.frame.height)
        self.view.addSubview(settingsButton)
        
        let layoutMargin : CGFloat = 22
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let settingsButtonTopEdgeConstraint = NSLayoutConstraint(item: settingsButton, attribute: .TopMargin, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: layoutMargin)
        let settingsButtonLeftEdgeConstraint = NSLayoutConstraint(item: settingsButton, attribute: .LeftMargin, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: layoutMargin )
        self.view.addConstraint(settingsButtonTopEdgeConstraint)
        self.view.addConstraint(settingsButtonLeftEdgeConstraint)
        
        settingsButton.onTap { (UITapGestureRecognizer) -> Void in
            XCGLogger.defaultInstance().debug("dismissButton.onTap")
            
            let alertController = UIAlertController(title: "Settings", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            alertController.addAction(UIAlertAction(title: "Close", style: .Destructive, handler: { (alertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            }))
            
            alertController.modalPresentationStyle = .Popover
            
            let popOverViewController = alertController.popoverPresentationController
            popOverViewController?.permittedArrowDirections = .Any
            popOverViewController?.sourceView = settingsButton
            popOverViewController?.sourceRect = settingsButton.bounds
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        // Setup info button
        let infoButton = UIButton()
        infoButton.setFAIcon(FAType.FAInfoCircle, iconSize: 36, forState: .Normal)
        infoButton.sizeToFit()
        infoButton.frame = CGRectMake(0, 0, infoButton.frame.width, infoButton.frame.height)
        self.view.addSubview(infoButton)
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        let infoButtonTopEdgeConstraint = NSLayoutConstraint(item: infoButton, attribute: .TopMargin, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: layoutMargin)
        let infoButtonRightEdgeConstraint = NSLayoutConstraint(item: infoButton, attribute: .RightMargin, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -layoutMargin )
        self.view.addConstraint(infoButtonTopEdgeConstraint)
        self.view.addConstraint(infoButtonRightEdgeConstraint)
        
        infoButton.onTap { (UITapGestureRecognizer) -> Void in
            XCGLogger.defaultInstance().debug("infoButton.onTap")
            
            dispatch_async(dispatch_get_main_queue(), {
                // http://stackoverflow.com/questions/24224916/presenting-a-uialertcontroller-properly-on-an-ipad-using-ios-8
                let alertController = UIAlertController(title: "Information Center", message: "To know more info", preferredStyle: UIAlertControllerStyle.ActionSheet)
                alertController.addAction(UIAlertAction(title: "台北村落之聲報導", style: .Default, handler: { (alertAction) -> Void in
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.urstaipei.net/archives/19470")!)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
                }))
                
                alertController.modalPresentationStyle = .Popover
                
                let popOverViewController = alertController.popoverPresentationController
                popOverViewController?.permittedArrowDirections = .Any
                popOverViewController?.sourceView = infoButton
                popOverViewController?.sourceRect = infoButton.bounds
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private
    
    func queryEvent() {
        self.loadingView.startAnimating()
        let eventQuery = Event.query()
        eventQuery!.whereKey("objectId", equalTo: self.eventObjectId)
        eventQuery?.includeKey("graphicCanvasPointer")
        eventQuery!.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            let eventObject = object as! Event
            
            self.eventObject = eventObject
            
            self.loadingView?.stopAnimating()
            XCGLogger.defaultInstance().debug("Event object: \(eventObject)")
            
            // Put image url to view
            self.mapImageView.imageFromUrl(eventObject.graphicCanvasPointer.imageFile.url!)
            self.mapImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            // Log
            XCGLogger.defaultInstance().debug("Compare image: w=\(CGFloat(eventObject.graphicCanvasPointer.dimensionsWidth)), h=\(CGFloat(eventObject.graphicCanvasPointer.dimensionsHeight))")
            
            // Caculate scale set
            self.painter?.calculateToFitLongSide(UIScreen.mainScreen().bounds.size, compareSize:
                CGSizeMake(CGFloat(eventObject.graphicCanvasPointer.dimensionsWidth),
                    CGFloat(eventObject.graphicCanvasPointer.dimensionsHeight)))
            
            XCGLogger.defaultInstance().debug("Painter: \(self.painter?.debugDescription)")
            
            self.painter?.currentScale = self.painter?.minScale
            
            
            let scaleWidth = Float((self.eventObject?.graphicCanvasPointer.dimensionsWidth)!) * (self.painter?.currentScale?.canvas)!
            let scaleHeight = Float((self.eventObject?.graphicCanvasPointer.dimensionsHeight)!) * (self.painter?.currentScale?.canvas)!
            
            self.mapImageView.frame = CGRectMake(0, 0, CGFloat(scaleWidth), CGFloat(scaleHeight))
            self.scrollView.contentSize = self.mapImageView.frame.size
            
            
            // Init blur effect
            self.mapViewBlurView = UIView()
            self.mapViewBlurView?.backgroundColor = UIColor.blackColor()
            self.mapViewBlurView!.alpha = BlurEffect.transparentAlpha
            self.mapViewBlurView!.hidden = true
            self.mapImageView.addSubview(self.mapViewBlurView!)
            
            self.queryStickersRelation(eventObject, mapViewFrame:self.mapImageView.frame)
        }
    }
    
    func scaleAorB(pinchGestureRecognizer : UIPinchGestureRecognizer) {
        
        if pinchGestureRecognizer.scale < 1 {
            self.painter?.currentScale = self.painter?.minScale
        } else {
            self.painter?.currentScale = self.painter?.maxScale
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            let scaleWidth = Float((self.eventObject?.graphicCanvasPointer.dimensionsWidth)!) * (self.painter?.currentScale?.canvas)!
            let scaleHeight = Float((self.eventObject?.graphicCanvasPointer.dimensionsHeight)!) * (self.painter?.currentScale?.canvas)!
            
            self.mapImageView.frame = CGRectMake(0, 0, CGFloat(scaleWidth), CGFloat(scaleHeight))
            self.scrollView.contentSize = self.mapImageView.frame.size
            
            // Update for the sticker view
            for view in self.mapImageView.subviews{
                let scale = (self.painter?.currentScale?.canvas)!
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    // Handle the subview
                })
            }
        })
    }
    
    func scaleFromPinch(pinchGestureRecognizer : UIPinchGestureRecognizer) {
        // Not now
        XCGLogger.defaultInstance().debug("Pinch scale: \(pinchGestureRecognizer.scale), velocity: \(pinchGestureRecognizer.velocity)")
        
        var scaleable : Bool = false
        
        scaleable = (self.painter?.transform(Float(pinchGestureRecognizer.scale)))!
        
        if scaleable {
            
            self.mapImageView.transform = CGAffineTransformMakeScale(pinchGestureRecognizer.scale, pinchGestureRecognizer.scale)
            self.mapImageView.frame = CGRectMake(0, 0, self.mapImageView.frame.size.width, self.mapImageView.frame.size.height)
            self.scrollView.contentSize = self.mapImageView.frame.size
            
            XCGLogger.defaultInstance().debug("Map image view frame: \(self.mapImageView!.frame)")
        }
    }
    
    /**
     Query the stickers and show up in mapview.
     
     - Parameters
     - eventObject:  The object contain event
     - mapViewFrame: Use for setup random in the area.
     */
    func queryStickersRelation(eventObject: Event, mapViewFrame: CGRect) {
        // Query relation out
        let stickersQuery : PFQuery = eventObject.graphicStickerRelation.query()!
        stickersQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
        stickersQuery.limit = 10
        stickersQuery.maxCacheAge = 5 * 60 * 1000
        stickersQuery.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
            
            self.loadingView?.stopAnimating()
            
            for view in self.mapImageView.subviews{
                view.removeFromSuperview()
            }
            self.mapImageView.addSubview(self.mapViewBlurView!)
            
            if objects != nil {
                
                let stickerInView : StickToViewManager = StickToViewManager()
                self.stickerObjects.removeAll()
                
                for object : PFObject in objects! {
                    let sticker = object as! Graphical
                    self.stickerObjects.append(sticker)
                    let view = self.createGraphicImageView(sticker, stickerInView: stickerInView)
                    self.mapImageView.addSubview(view)
                }
            }
            
        })
    }
    
    func createGraphicImageView(sticker: Graphical, stickerInView: StickToViewManager) -> UIImageView {
        
        let view: GraphicImageView = GraphicImageView()
        
        // Setup data
        view.graphicInfo = sticker
        
        // Load image
        view.imageFromUrl(sticker.imageFile.url!, outlineColor: UIColor.whiteColor())
        view.contentMode = UIViewContentMode.ScaleAspectFill
        
        // Find a random position for the color view, that doesn't intersect other views.
        // Setup scale size
        let scaleWidth : CGFloat = CGFloat(Float(sticker.dimensionsWidth) * (self.painter?.currentScale?.sticker)!)
        let scaleHeight : CGFloat = CGFloat(Float(sticker.dimensionsHeight) * (self.painter?.currentScale?.sticker)!)
        let withSize: CGSize = CGSizeMake(scaleWidth, scaleHeight)
        let randomPoint: CGPoint = stickerInView.randomRectWithNoIntersect(self.mapImageView, withSize:withSize)
        let randomRect : CGRect = CGRectMake(randomPoint.x, randomPoint.y, withSize.width, withSize.height)
        view.frame = randomRect
        
        // Setup user iteraction
        view.userInteractionEnabled = true
        
        // Support drag
        let holdDragRecognizer:BFDragGestureRecognizer = BFDragGestureRecognizer()
        holdDragRecognizer.addTarget(self, action:"dragRecognized:")
        view.addGestureRecognizer(holdDragRecognizer)
        
        // Support tap
        view.onTap({ (UITapGestureRecognizer) -> Void in
            XCGLogger.defaultInstance().debug("View.frame = \(view.frame)")
            
            // FIXME: Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
            
            /// Popover http://stackoverflow.com/questions/24635744/how-to-present-popover-properly-in-ios-8
            let popViewController: StickerInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StickerInfoViewController") as! StickerInfoViewController
            
            popViewController.sticker = sticker
            
            popViewController.modalPresentationStyle = .Popover
            popViewController.preferredContentSize = CGSizeMake(400, 300)
            
            let popOverViewController = popViewController.popoverPresentationController
            popOverViewController?.permittedArrowDirections = .Any
            popOverViewController?.sourceView = self.mapImageView
            popOverViewController?.sourceRect = CGRectMake(view.center.x, view.center.y, 1, 1)
            
            self.presentViewController(popViewController, animated: true, completion: { () -> Void in
                popViewController.contentTextView.scrollRangeToVisible(NSMakeRange(0, 1))
            })
        })
        
        return view
    }
    
    /**
     Handle drag recoginized
     - Parameters
     - recoginzer: Passing recoginzer view
     - Returns: no
     */
    func dragRecognized(recognizer:BFDragGestureRecognizer) {
        let view: UIView! = recognizer.view
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            
            // Start blur effect
            self.mapViewBlurView!.hidden = false
            
            self.mapViewBlurView!.frame = self.mapImageView.bounds
            
            startCenter = view.center
            
            view.superview!.bringSubviewToFront(view)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                view.transform  = CGAffineTransformMakeScale(1.2, 1.2)
                view.alpha = 0.7
            })
            
        } else if (recognizer.state == UIGestureRecognizerState.Changed) {
            
            let translation : CGPoint = recognizer.translationInView(mapImageView)
            let center: CGPoint = CGPointMake(startCenter.x + translation.x, startCenter.y + translation.y)
            view.center = center
            
        } else if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled) {
            
            self.mapViewBlurView!.hidden = true
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                view.transform  = CGAffineTransformIdentity
                view.alpha = 1.0
            })
            
        }
    }
    
    class GraphicImageView: UIImageView {
        var graphicInfo : Graphical?
    }
    
}

