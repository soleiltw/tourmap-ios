//
//  Painter.swift
//  TourMap
//
//  Created by Edward Chiang on 12/15/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import XCGLogger

public class Painter: NSObject {
    
    var currentScale : Scale?
    
    var maxScale : Scale?
    
    var minScale : Scale?
    
    init(current: Float) {
        currentScale = Scale(canvas: current, sticker: current)
    }
    
    public func transform(scale: Float) -> Bool {
        let nextScale = (self.currentScale?.canvas)! * scale
        
        if nextScale > self.minScale?.canvas && nextScale < self.maxScale?.canvas {
            self.currentScale = Scale(canvas: nextScale, sticker: nextScale)
            XCGLogger.defaultInstance().debug("Can Next Scale: \(nextScale)")
            return true
        } else {
            // Out of range
            XCGLogger.defaultInstance().debug("Not Next Scale: \(nextScale)")
            return false
        }
    }

    public func calculateForScale(screenSize: CGSize, compareSize: CGSize) {
        if (screenSize.width * screenSize.height < compareSize.width * compareSize.height) {
            let scaleSet : Float = max(Float(screenSize.width / compareSize.width) , Float(screenSize.height / compareSize.height))
            maxScale = Scale(canvas: 1.0, sticker: 1.0)
            minScale = Scale(canvas: scaleSet, sticker: scaleSet)
        } else {
            let scaleSet : Float = max(Float(compareSize.width / screenSize.width) , Float(compareSize.height / screenSize.height))
            minScale = Scale(canvas: 1.0, sticker: 1.0)
            maxScale = Scale(canvas: scaleSet, sticker: scaleSet)
        }
    }
    
    public func calculateToFitLongSide(screenSize: CGSize, compareSize: CGSize) {
        let longSide = max(screenSize.width, screenSize.height)
        
        if (screenSize.width * screenSize.height < compareSize.width * compareSize.height) {
            let scaleSet : Float = max(Float(longSide / compareSize.width) , Float(longSide / compareSize.height))
            maxScale = Scale(canvas: 1.0, sticker: 1.0)
            minScale = Scale(canvas: scaleSet, sticker: scaleSet)
        } else {
            let scaleSet : Float = max(Float(compareSize.width / longSide) , Float(compareSize.height / longSide))
            minScale = Scale(canvas: 1.0, sticker: 1.0)
            maxScale = Scale(canvas: scaleSet, sticker: scaleSet)
        }
    }
    
    override public var debugDescription : String {
        return "Scale Max=\(self.maxScale!), Min=\(self.minScale!)"
    }
    
    struct Scale {
        var canvas : Float
        var sticker : Float
    }
}