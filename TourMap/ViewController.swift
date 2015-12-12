//
//  ViewController.swift
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

/// The canvas demo class to present image and gesture.
class ViewController: UIViewController {

    var mapViewBlurView: UIView?
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// The canvas need to transform scale.
    var canvasTransformScale : Float = 0.6
    
    var stickerTransformScale : Float = 0.6
    
    var blurEffectAlpha : CGFloat = 0.6
    
    var mapImageView: UIImageView!
    var startCenter: CGPoint!
    
    var infoButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XCGLogger.defaultInstance().debug("UIScreen.mainScreen().bounds = \(UIScreen.mainScreen().bounds)")

        // Init map image view
        self.mapImageView = UIImageView()
        self.mapImageView.userInteractionEnabled = true
        self.mapImageView.frame = CGRectZero
        self.scrollView.contentSize = mapImageView.frame.size
        self.scrollView.addSubview(mapImageView)
        
        // Query from parse
        loadingView?.startAnimating()
        let eventQuery = Event.query()
        eventQuery!.whereKey("objectId", equalTo: "UdCDGMudrh")
        eventQuery?.includeKey("graphicCanvasPointer")
        eventQuery!.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            let eventObject = object as! Event
            self.loadingView?.stopAnimating()
            XCGLogger.defaultInstance().debug("Event object: \(eventObject)")
            
            // Put image url to view
            self.mapImageView.imageFromUrl(eventObject.graphicCanvasPointer.imageFile.url!)
            self.mapImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            let scaleWidth = Float(eventObject.graphicCanvasPointer.dimensionsWidth) * self.canvasTransformScale
            let scaleHeight = Float(eventObject.graphicCanvasPointer.dimensionsHeight) * self.canvasTransformScale
            
            self.mapImageView.frame = CGRectMake(0, 0, CGFloat(scaleWidth), CGFloat(scaleHeight))
            self.scrollView.contentSize = self.mapImageView.frame.size
            
            // Init blur effect
            self.mapViewBlurView = UIView()
            self.mapViewBlurView?.backgroundColor = UIColor.blackColor()
            self.mapViewBlurView!.alpha = self.blurEffectAlpha
            self.mapViewBlurView!.hidden = true
            self.mapImageView.addSubview(self.mapViewBlurView!)
            
            self.queryStickersRelation(eventObject, mapViewFrame:self.mapImageView.frame)
        }
        
        // Add pinch gesture
        self.mapImageView.onPinch { (pinchGestureRecognizer) -> Void in
            XCGLogger.defaultInstance().debug("Pinch scale: \(pinchGestureRecognizer.scale), velocity: \(pinchGestureRecognizer.velocity)")
        }
        
        // Setup info button
        infoButton = UIButton()
        self.infoButton.setFAIcon(FAType.FAInfoCircle, iconSize: 36, forState: .Normal)
        self.infoButton.sizeToFit()
        self.infoButton.frame = CGRectMake(0, 0, self.infoButton.frame.width, self.infoButton.frame.height)
        self.view.addSubview(infoButton)
        
        self.infoButton.translatesAutoresizingMaskIntoConstraints = false
        
        let infoButtonTopEdgeConstraint = NSLayoutConstraint(item: self.infoButton, attribute: .TopMargin, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 36)
        
        let infoButtonRightEdgeConstraint = NSLayoutConstraint(item: self.infoButton, attribute: .RightMargin, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -36 )
        
        self.view.addConstraint(infoButtonTopEdgeConstraint)
        self.view.addConstraint(infoButtonRightEdgeConstraint)
        
        self.infoButton.onTap { (UITapGestureRecognizer) -> Void in
            XCGLogger.defaultInstance().debug("infoButton.onTap")
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
        let stickersQuery = eventObject.graphicStickerRelation.query()
        stickersQuery?.findObjectsInBackgroundWithBlock({ (objects : [PFObject]?, error: NSError?) -> Void in
    
            self.loadingView?.stopAnimating()
            
            if objects != nil {
                
                let stickerInView : StickToViewManager = StickToViewManager()
                
                for object : PFObject in objects! {
                
                    let sticker = object as! Graphical
                    
                    // Setup scale size
                    let scaleWidth : CGFloat = CGFloat(Float(sticker.dimensionsWidth) * self.stickerTransformScale)
                    let scaleHeight : CGFloat = CGFloat(Float(sticker.dimensionsHeight) * self.stickerTransformScale)
                    
                    let withSize: CGSize = CGSizeMake(scaleWidth, scaleHeight)
                    
                    // Find a random position for the color view, that doesn't intersect other views.
                    let randomPoint: CGPoint = stickerInView.randomRect(self.mapImageView.frame, withSize:withSize)
                    let randomRect : CGRect = CGRectMake(randomPoint.x, randomPoint.y, withSize.width, withSize.height)
                    
                    let view: UIImageView = UIImageView()
                    
                    view.imageFromUrl(sticker.imageFile.url!, outlineColor: UIColor.whiteColor())
                    view.contentMode = UIViewContentMode.ScaleAspectFill
                    view.frame = randomRect
                    view.userInteractionEnabled = true
                    
                    self.mapImageView.addSubview(view)
                    
                    let holdDragRecognizer:BFDragGestureRecognizer = BFDragGestureRecognizer()
                    holdDragRecognizer.addTarget(self, action:"dragRecognized:")
                    view.addGestureRecognizer(holdDragRecognizer)
                    
                    view.onTap({ (UITapGestureRecognizer) -> Void in
                        XCGLogger.defaultInstance().debug("View.frame = \(view.frame)")
                        
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
                }
            }
            
        })
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


