//
//  ScratchPaperView.swift
//  Scratch Paper
//
//  Created by CHENGJUN LU on 7/1/18.
//  Copyright © 2018 CHENGJUN LU. All rights reserved.
//

import UIKit

class ScratchPaperTableView: UIView {
    
    var line = [Line]()
    var lastPoint = CGPoint()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        if let touch = touches.first{
            lastPoint = touch.location(in: self)
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            var newPoint = touch.location(in: self)
            line.append(Line(start: lastPoint, end: newPoint))
            lastPoint = newPoint
            self.setNeedsDisplay()
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        for points in line {
            context?.move(to: CGPoint(x: points.startPoint.x, y: points.startPoint.y))
            context?.addLine(to: CGPoint(x: points.endPoint.x, y: points.endPoint.y))
        }
        context?.setLineCap(.round)
        context?.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context?.strokePath()
        
        
    }
    
    
}
