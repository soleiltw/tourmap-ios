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

class CollectionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        self.loadingView.hidden = false
        self.loadingView.startAnimating()
        let eventQuery : PFQuery = Event.query()!
        eventQuery.includeKey("graphicCanvasPointer")
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageCollectionCell", forIndexPath: indexPath)
        
        // Cast to certain cell
        let eventObject : Event = events[indexPath.row]
        let eventCell : EventCollectionViewCell = cell as! EventCollectionViewCell
        eventCell.imageView.af_setImageWithURL(NSURL(string: eventObject.graphicCanvasPointer.imageFile.url!)!)
        eventCell.nameLabel.text = eventObject.name
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        segue.destinationViewController
        if  segue.identifier == "showDemo" {
            let demoViewController : DemoViewController = segue.destinationViewController as! DemoViewController
            demoViewController.eventObjectId = Demo.defaultEventObjectId
        }
    }

}
