//
//  ViewController.swift
//  Scratch Paper
//
//  Created by CHENGJUN LU on 7/1/18.
//  Copyright © 2018 CHENGJUN LU. All rights reserved.
//

import UIKit

class ScratchPaperViewController:UIViewController {

    @IBOutlet weak var paperView: ScratchPaperView!
    @IBOutlet weak var coloBrushOpcityPanel: UIView!
    
    
    
   // let colorArray = ["Black","Brown","Gray","Green","Blue","Orange","Purple","Yellow","Red","Pink","LGreen","LBlue"]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coloBrushOpcityPanel.isHidden = true
        
        loadDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()// Do any additional setup after loading the view, typically from a nib.\
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func penButtomPressed(_ sender: UIButton) {
        coloBrushOpcityPanel.isHidden = false
        
        
    }
    
  
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        
        attribute.instance.colorIndex = sender.tag
    
    }
//
//    func setContextColor(red: Float = 0, green: Float = 0, blue: Float){
//
//        for points in paperView.drawContextArray {
//
//            points.colorR = red
//            points.colorG = green
//            points.colorB = blue
//
//        }
//
//
//    }
    
    
    
    //self.setNeedsDisplay()
  
  
    @IBAction func clearButtomPressed(_ sender: UIButton) {
        
         deleteDrawingContext()
        
    }
    
    
    
    func loadDrawingContext(){
        paperView.loadDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
    }
    
    
    func deleteDrawingContext(){
        
//        paperView.isHidden = true
        
        while !paperView.drawContextArray.isEmpty {
            paperView.drawContextArray.popLast()
        }
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
        
    }
    



}

