//
//  Graphical.swift
//  TourMap
//
//  Created by Edward Chiang on 12/1/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import Foundation
import Parse

/// Graphical object hold the data from Parse
public class Graphical: PFObject, PFSubclassing {
    @NSManaged var name: String?
    @NSManaged var imageFile : PFFile
    @NSManaged var dimensionsWidth : Int
    @NSManaged var dimensionsHeight : Int
    
    override public class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    /**
     Refrence class name to Parse
     
     - returns: The class name on Parse
     */
    public static func parseClassName() -> String {
        return "Graphical"
    }
}
