//
//  EventCollectionViewCell.swift
//  TourMap
//
//  Created by Edward Chiang on 12/16/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // http://stackoverflow.com/questions/805872/how-do-i-draw-a-shadow-under-a-uiview
        // http://stackoverflow.com/questions/25591389/uiview-with-shadow-rounded-corners-and-custom-drawrect
        
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        
        self.clipsToBounds = false
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                // http://stackoverflow.com/questions/25005259/objective-c-setter-overriding-in-swift
                setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        if  self.highlighted {
            // http://stackoverflow.com/questions/15483229/where-to-highlight-uicollectionviewcell-delegate-or-cell
            let context : CGContextRef = UIGraphicsGetCurrentContext()!;
            // Light gray [UIColor colorWithRed:0.894  green:0.894  blue:0.894 alpha:1]
            CGContextSetRGBFillColor(context, 0.894, 0.894, 0.894, 0.3);
            CGContextFillRect(context, self.bounds);
        }
    }
}
