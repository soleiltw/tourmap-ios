//
//  UIImageView+Extension.swift
//  TourMap
//
//  Created by Edward Chiang on 12/1/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /**
     Load image from given url string.
     
     - parameter urlString: The image url want to load
     */
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    /**
        The description
     
        - parameter object:
        - returns:
     */
    public func imageFromUrl(urlString: String, outlineColor: UIColor) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    self.image = self.drawOutlien(self.image!, color: outlineColor)
                }
            }
        }
    }
    
    /**
        Draw border around content of image. Refrence from [Draw border around content of UIImageView](http://stackoverflow.com/questions/25807455/draw-border-around-content-of-uiimageview)
     
        - parameter image: The original image.
        - parameter color: The color for border.
        - returns: The image with border color.
    */
    public func drawOutlien(image:UIImage, color:UIColor) -> UIImage {
        
        let newImageKoef:CGFloat = 1.1
        
        let outlinedImageRect = CGRect(x: 0.0, y: 0.0, width: image.size.width * newImageKoef, height: image.size.height * newImageKoef)
        
        let imageRect = CGRect(x: image.size.width * (newImageKoef - 1) * 0.5, y: image.size.height * (newImageKoef - 1) * 0.5, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(outlinedImageRect.size, false, newImageKoef)
        
        image.drawInRect(outlinedImageRect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetBlendMode(context, CGBlendMode.SourceIn)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, outlinedImageRect)
        image.drawInRect(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
