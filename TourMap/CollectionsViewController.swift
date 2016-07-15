//
//  CollectionsViewController.swift
//  TourMap
//
//  Created by Edward Chiang on 12/16/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import XCGLogger

struct CollectionViewCellSize {
    static let iPadWidth : CGFloat = 280
    static let iPadHeight : CGFloat = 220
    static let iPhoneWidth : CGFloat = 200
    static let iPhoneHeight : CGFloat = 140
}

class CollectionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        self.loadingView.hidden = false
        self.loadingView.startAnimating()
        let eventQuery : PFQuery = Event.query()!
        eventQuery.includeKey("graphicCanvasPointer")
        eventQuery.includeKey("graphicStickerRelation")
        eventQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            self.loadingView.stopAnimating()
            self.loadingView.hidden = true
            if  objects != nil {
                self.events.removeAll()
                for eventParseObject : PFObject in objects! {
                    let eventCastObject : Event = eventParseObject as! Event
                    self.events.append(eventCastObject)
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell = UICollectionViewCell()
        if ( UI_USER_INTERFACE_IDIOM() == .Pad ) {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageIPadCell", forIndexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageIPhoneCell", forIndexPath: indexPath)
        }
        
        // Cast to certain cell
        let eventObject : Event = events[indexPath.row]
        let eventCell : EventCollectionViewCell = cell as! EventCollectionViewCell
        
        XCGLogger.debug("Load image url: \(eventObject.graphicCanvasPointer.imageFile.url! as String)")
        
        eventCell.imageView.af_setImageWithURL(NSURL(string: eventObject.graphicCanvasPointer.imageFile.url!)!)
        eventCell.nameLabel.text = eventObject.name
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        // To get the best of width for collection view.
        let wideWidth : Int = Int(max(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame)))
        
        var eachCellWidth : CGFloat = CGFloat(CollectionViewCellSize.iPadWidth)
        if ( UI_USER_INTERFACE_IDIOM() == .Phone ) {
            eachCellWidth = CGFloat(CollectionViewCellSize.iPhoneWidth)
        }
        
        let numberOfInSection : Int = 2
        let edgeInsets = CGFloat((wideWidth - Int(eachCellWidth) * numberOfInSection) / (numberOfInSection + 1))
        if edgeInsets > 10 {
            return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
        } else {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        if ( UI_USER_INTERFACE_IDIOM() == .Phone ) {
            return CGSizeMake(CollectionViewCellSize.iPhoneWidth, CollectionViewCellSize.iPhoneHeight)
        }
        return CGSizeMake(CollectionViewCellSize.iPadWidth, CollectionViewCellSize.iPadHeight)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        segue.destinationViewController
        if  segue.identifier == "showDemo" {
            let demoViewController : DemoViewController = segue.destinationViewController as! DemoViewController
            
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            let eventObject : Event = events[indexPath!.row]
            
            demoViewController.eventObjectId = eventObject.objectId!
        }
    }

}
