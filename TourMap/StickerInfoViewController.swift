//
//  StickerInfoViewController.swift
//  TourMap
//
//  Created by Edward Chiang on 12/2/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit

class StickerInfoViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var sticker: Graphical?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = sticker?.name
        
        // Text content start from the top
        // http://stackoverflow.com/questions/26835944/uitextview-text-content-doesnt-start-from-the-top
        self.contentTextView.scrollRangeToVisible(NSMakeRange(0, 1))
    }

    /**
     To dismiss current view controller
     
     - parameter sender: The touched object
     */
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
