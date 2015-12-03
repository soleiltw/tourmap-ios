//
//  TMEvent.swift
//  TourMap
//
//  Created by Edward Chiang on 12/1/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import Foundation
import Parse

/// Event object hold the data from Parse
public class TMEvent : PFObject, PFSubclassing {
    
    @NSManaged var name : String
    @NSManaged var graphicCanvasPointer : TMGraphical
    
    var graphicStickerRelation : PFRelation! {
        return objectForKey("graphicStickerRelation") as? PFRelation
    }
    
    /**
        To initialize for the Parse object.
     */
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
        return "Event"
    }
}
