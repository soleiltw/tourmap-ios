//
//  UIImageView+Extension.swift
//  TourMap
//
//  Created by Edward Chiang on 12/1/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import Foundation

extension UIImageView {
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
}
