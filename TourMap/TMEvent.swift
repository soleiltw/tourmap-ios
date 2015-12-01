//
//  TMEvent.swift
//  TourMap
//
//  Created by Edward Chiang on 12/1/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import Foundation
import Parse

class TMEvent : PFObject, PFSubclassing {
    
    @NSManaged var name : String
    @NSManaged var graphicCanvasPointer : TMGraphical
    
    var graphicStickerRelation : PFRelation! {
        return objectForKey("graphicStickerRelation") as? PFRelation
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
}
