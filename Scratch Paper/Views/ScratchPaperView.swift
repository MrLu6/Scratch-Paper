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
    var undoRedoContextStack = [DrawContext]()
    
    
    var previousPoint1: CGPoint?
    var previousPoint2: CGPoint?
    var currentPoint: CGPoint?
    
    //var touchBeginPointArray: [CGPoint] = []
    var touchBeginPointArray = [TouchBeginPoint]()
    
    //var touchEndPointArray: [CGPoint] = []
    var touchEndPointArray = [TouchEndPoint]()
   
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            
          previousPoint1 = touch.location(in: self)
            
            
            let newTouchBeginPoint = TouchBeginPoint(context:self.context)
            newTouchBeginPoint.x = Float ((previousPoint1?.x)!)
            newTouchBeginPoint.y = Float((previousPoint1?.y)!)
            touchBeginPointArray.append(newTouchBeginPoint)
            save()
            
          //touchBeginPointArray.append(touch.location(in: self))
           
          //print("First touch point: \(touch.location(in: self)) \n")
            
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
        
        
       if attribute.instance.colorPanelIsEnable == false {
            drawContextArray.append(newDrawingContext)
            save()
            self.setNeedsDisplay()
       }
        
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
           // print("end point in draw:\(CGPoint(x: previousPoint1X, y:previousPoint1Y ))")
            context?.setLineCap(.round)
            
            context?.setStrokeColor(red:CGFloat(points.colorR), green: CGFloat(points.colorG), blue: CGFloat(points.colorB), alpha: CGFloat(points.numOpacity))
            context?.setLineWidth(CGFloat(points.numBrush))
            context?.strokePath()
            
        }
  
    }
    
    
    func setContextColor(newDrawingContext: DrawContext ){
       
        if attribute.instance.eraserEnable == true {
            //print("eraserEnable is true")
            newDrawingContext.colorR = Float(1)
            newDrawingContext.colorG = Float(1)
            newDrawingContext.colorB = Float(1)
        }else{
     
            newDrawingContext.colorR = attribute.instance.colorRGB[attribute.instance.colorIndex].0
            newDrawingContext.colorG = attribute.instance.colorRGB[attribute.instance.colorIndex].1
            newDrawingContext.colorB = attribute.instance.colorRGB[attribute.instance.colorIndex].2
            
        }

    }
    
    func setContextLineWith(newDrawingContext: DrawContext ){
        
        newDrawingContext.numBrush = attribute.instance.numBrush
        
    }
    
    func setContextAlpah(newDrawingContext: DrawContext){
        if attribute.instance.eraserEnable == true{
            newDrawingContext.numOpacity = Float(1)
        }else{
            newDrawingContext.numOpacity = attribute.instance.numOpacity
        }
        
    }
        

    func save(){
        
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
    
    func loadTochBeginPoint(){
        
        let request: NSFetchRequest<TouchBeginPoint> = TouchBeginPoint.fetchRequest()
        
        do{
            touchBeginPointArray = try context.fetch(request)
        }catch{
            print("Error occurs when loading context\(error)")
        }
    }
    
    func loadTochEndPoint(){
        
        let request: NSFetchRequest<TouchEndPoint> = TouchEndPoint.fetchRequest()
        
        do{
            touchEndPointArray = try context.fetch(request)
        }catch{
            print("Error occurs when loading context\(error)")
        }
    }
    
    
    func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2.0, y: (p1.y + p2.y) / 2.0)
    }
    
    
    func undo(){
//
//        print("drawContextArray.count \(drawContextArray.count)")
//        print("touchBeginPointArray.count \(touchEndPointArray.count)")
        
        //
        if !drawContextArray.isEmpty && !touchBeginPointArray.isEmpty {
            
            var currentContext = drawContextArray.removeLast()
            
            var currentPoint = CGPoint(x: CGFloat(currentContext.mid1X), y: CGFloat(currentContext.mid1Y))
           // print("undo start point\(currentPoint)")
            let newTouchEndPoint = TouchEndPoint(context: self.context)
            newTouchEndPoint.x = Float(currentPoint.x)
            newTouchEndPoint.y = Float(currentPoint.y)
            touchEndPointArray.append(newTouchEndPoint)
            save()
            //fix
            let tempPoint = touchBeginPointArray.removeLast()
            let lastBeginTouchPoint = CGPoint(x: CGFloat(tempPoint.x), y: CGFloat(tempPoint.y))
            
            undoRedoContextStack.append(currentContext)
           
            //context.delete(currentContext)
            
            while (lastBeginTouchPoint != currentPoint && !drawContextArray.isEmpty){
                currentContext = drawContextArray.removeLast()
                currentPoint = CGPoint(x: CGFloat(currentContext.mid1X), y: CGFloat(currentContext.mid1Y))
                undoRedoContextStack.append(currentContext)
                //context.delete(currentContext)
                
            }
            
            //print("end of undo Point\(currentPoint)")
            
            save()
            self.setNeedsDisplay()
            
        }
        
        
    }
    
    func redo(){
        
        print("undoRedoContextStack.count \(undoRedoContextStack.count)")
        print("touchEndPointArray.count \(touchEndPointArray.count)")
        
        
        if !undoRedoContextStack.isEmpty && !touchEndPointArray.isEmpty {
            
            var currentContext = undoRedoContextStack.removeLast()
            
            
            drawContextArray.append(currentContext)
           
            
            var currentPoint = CGPoint(x: CGFloat(currentContext.mid1X), y: CGFloat(currentContext.mid1Y))
            
            
           // fix  touchBeginPointArray.append(currentPoint)
            let newTouchBeginPoint = TouchBeginPoint(context:self.context)
            newTouchBeginPoint.x = Float (currentPoint.x)
            newTouchBeginPoint.y = Float(currentPoint.y)
            touchBeginPointArray.append(newTouchBeginPoint)
            save()

            
           // print("start of append point \(currentPoint)")
            let tempPoint = touchEndPointArray.removeLast()
            let lastEndTouchPoint = CGPoint(x: CGFloat(tempPoint.x), y: CGFloat(tempPoint.y))
            //print("lastEndTouchPoint \(lastEndTouchPoint)")
            
            while (lastEndTouchPoint != currentPoint && !undoRedoContextStack.isEmpty ){
                currentContext = undoRedoContextStack.removeLast()
                currentPoint = CGPoint(x: CGFloat(currentContext.mid1X), y: CGFloat(currentContext.mid1Y))
                drawContextArray.append(currentContext)
            }
            
           // print("end of append point in lastEndTouchPoint \(lastEndTouchPoint)")
           // print("end of append point in stack \(currentPoint)")
            
            
            
            save()
            self.setNeedsDisplay()
        }
        

    }
    
    
//
//    func controlColorPanelEnable(){
//
//        if !attribute.instance.colorPanelIsEnable{
//            attribute.instance.numClikedWhenColorPanelIsEnable += 1
//        }
//
//        if attribute.instance.numClikedWhenColorPanelIsEnable == 2 {
//            print("I get called num hit 2")
//            colorPanelView.isHidden = true
//            print("colorPanelView.isHidden \(colorPanelView.isHidden)")
//            attribute.instance.numClikedWhenColorPanelIsEnable = 0
//        }
//
//
//    }
    
    
}

