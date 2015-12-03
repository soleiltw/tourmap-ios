//
//  TMStickToViewManager.swift
//  TourMap
//
//  Created by Edward Chiang on 12/3/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit

/// A manager to handle sticker to parent view.
public class TMStickToViewManager: NSObject {
    
    /**
     Generate random point.
     
     - Parameters
        - refrenceFrame: For the boundary.
     
     - returns: The random point.
     */
    public func randomRect(refrenceFrame: CGRect, withSize:CGSize) -> CGPoint {
        var randomPoint : CGPoint = CGPointZero
        randomPoint = CGPointMake(CGFloat(random()) % (CGRectGetWidth(refrenceFrame) - withSize.width), CGFloat(random()) % (CGRectGetHeight(refrenceFrame) - withSize.height));
        
        return randomPoint
    }
    
    /**
     Generate random rect for the given view.
     
     - Parameters
        - refrenceView: The refrence main view
        - withSize: With the size to compare
     - returns: The point that fit for the view.
     */
    public func randomRectWithNoIntersect(refrenceView: UIView, withSize:CGSize) -> CGPoint {
        var randomPoint : CGPoint = CGPointZero
        var canPlace = false
        while (!canPlace) {
            randomPoint = CGPointMake(CGFloat(random()) % CGRectGetWidth(refrenceView.frame), CGFloat(random()) % CGRectGetHeight(refrenceView.frame));
            
            // Make sure not to out of bound
            let randomRect : CGRect = CGRectMake(randomPoint.x, randomPoint.y, withSize.width, withSize.height)
            
            canPlace = true
            for subview: UIView in refrenceView.subviews {
                if (CGRectIntersectsRect(randomRect, subview.frame) ||
                    CGRectGetMaxX(randomRect) > CGRectGetMaxX(refrenceView.frame) || CGRectGetMaxY(randomRect) > CGRectGetMaxY(refrenceView.frame)) {
                        canPlace = false
                        break
                }
            }
        }
        return randomPoint
    }

}
