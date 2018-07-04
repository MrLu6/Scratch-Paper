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
   
    
    var lastPoint = CGPoint()
   

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first{
            lastPoint = touch.location(in: self)
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
           // print("touch move get call")
            let newDrawingContext = DrawContext(context: self.context)
            let newPoint = touch.location(in: self)
            
            
            
            newDrawingContext.startX = Float(lastPoint.x)
            newDrawingContext.startY = Float(lastPoint.y)
            newDrawingContext.endX = Float(newPoint.x)
            newDrawingContext.endY = Float(newPoint.y)
            setContextColor(newDrawingContext: newDrawingContext)
            
            lastPoint = newPoint
            drawContextArray.append(newDrawingContext)
            saveDrawingContext()
            self.setNeedsDisplay()
            
        }
        
    }
    
    override func draw(_ rect: CGRect) {
       
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        for points in drawContextArray{
            
            let fromX = CGFloat(points.startX)
            let fromY = CGFloat(points.startY)
            let toX = CGFloat(points.endX)
            let toY = CGFloat(points.endY)
            context?.move(to: CGPoint(x: fromX, y: fromY))
            context?.addLine(to: CGPoint(x: toX, y: toY))
            
            context?.setLineCap(.round)
            context?.setStrokeColor(red:CGFloat(points.colorR), green: CGFloat(points.colorG), blue: CGFloat(points.colorB), alpha: 1)
            context?.setLineWidth(5)
            context?.strokePath()
            
            
        }
  
        
        
        
    }
    
    
    func setContextColor(newDrawingContext: DrawContext ){
       // print("setColor get called")
        newDrawingContext.colorR = attribute.instance.colorRGB[attribute.instance.colorIndex].0
        newDrawingContext.colorG = attribute.instance.colorRGB[attribute.instance.colorIndex].1
        newDrawingContext.colorB = attribute.instance.colorRGB[attribute.instance.colorIndex].2
        
//        print("Index \(attribute.instance.colorIndex)")
//        print("red \(newDrawingContext.colorR ) \n")
//        print("green \(newDrawingContext.colorG ) \n")
//        print("blue \(newDrawingContext.colorB ) \n")

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
    
    
}

