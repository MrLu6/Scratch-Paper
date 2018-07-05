//
//  ScratchPaperView.swift
//  Scratch Paper
//
//  Created by CHENGJUN LU on 7/1/18.
//  Copyright © 2018 CHENGJUN LU. All rights reserved.
//

import UIKit
import CoreData

class ScratchPaperView: UIView {
    
    var drawContextArray  = [DrawContext]()
    
    //let ScratchPaperCL = ScratchPaperViewController()
    

    var lastPoint = CGPoint()
    
    var previousPoint1: CGPoint?
    var previousPoint2: CGPoint?
    var currentPoint: CGPoint?
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        
        if let touch = touches.first{
           previousPoint1 = touch.location(in: self)
            
           
          
        }
        
    }
    
    
    //credit kyoji
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let previousPoint2 = previousPoint1
        previousPoint1 = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        
        
        // calculate mid point
        let mid1 = midPoint(p1: previousPoint1!, p2: previousPoint2!)
        let mid2 = midPoint(p1: currentPoint, p2: previousPoint1!)
        let newDrawingContext = DrawContext(context: self.context)
        
        newDrawingContext.mid1X = Float(mid1.x)
        newDrawingContext.mid1Y = Float(mid1.y)
        
        newDrawingContext.mid2X = Float(mid2.x)
        newDrawingContext.mid2Y = Float(mid2.y)
        
        newDrawingContext.previousPoint1X = Float((previousPoint1?.x)!)
        newDrawingContext.previousPoint1Y = Float((previousPoint1?.y)!)
        
        setContextColor(newDrawingContext: newDrawingContext)
        setContextLineWith(newDrawingContext: newDrawingContext)
        setContextAlpah(newDrawingContext: newDrawingContext)
        
        drawContextArray.append(newDrawingContext)
        saveDrawingContext()
        self.setNeedsDisplay()


    }
    
    override func draw( _ rect: CGRect) {
       
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        for points in drawContextArray{
            
            let mid1X = CGFloat(points.mid1X)
            let mid1Y = CGFloat(points.mid1Y)
            let mid2X = CGFloat(points.mid2X)
            let mid2Y = CGFloat(points.mid2Y)
            let previousPoint1X = CGFloat(points.previousPoint1X)
            let previousPoint1Y = CGFloat(points.previousPoint1Y)
            
            
            context?.move(to: CGPoint(x:mid1X, y: mid1Y))
            context?.addQuadCurve(to: CGPoint(x: mid2X, y: mid2Y), control: CGPoint(x: previousPoint1X, y:previousPoint1Y ))
            context?.setLineCap(.round)
            context?.setStrokeColor(red:CGFloat(points.colorR), green: CGFloat(points.colorG), blue: CGFloat(points.colorB), alpha: CGFloat(points.numOpacity))
            context?.setLineWidth(CGFloat(points.numBrush))
            context?.strokePath()
            
            
            
        }
  
        
        
        
    }
    
    
    func setContextColor(newDrawingContext: DrawContext ){
       
        newDrawingContext.colorR = attribute.instance.colorRGB[attribute.instance.colorIndex].0
        newDrawingContext.colorG = attribute.instance.colorRGB[attribute.instance.colorIndex].1
        newDrawingContext.colorB = attribute.instance.colorRGB[attribute.instance.colorIndex].2

    }
    
    func setContextLineWith(newDrawingContext: DrawContext ){
        
        newDrawingContext.numBrush = attribute.instance.numBrush
        
    }
    
    func setContextAlpah(newDrawingContext: DrawContext){
        
        newDrawingContext.numOpacity = attribute.instance.numOpacity
        
    }
        
        
    
    func saveDrawingContext(){
        
        do{
            try context.save()
            //print(context)
        }catch{
            print("Error occurs when saving context\(error)")
        }
        
    }
    
    func loadDrawingContext(){
        
        let request: NSFetchRequest<DrawContext> = DrawContext.fetchRequest()
        
        do{
            drawContextArray = try context.fetch(request)
        }catch{
            print("Error occurs when loading context\(error)")
        }
        
        
    }
    
    func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2.0, y: (p1.y + p2.y) / 2.0)
    }
    
    
}

