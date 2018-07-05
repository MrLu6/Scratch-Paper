//
//  ViewController.swift
//  Scratch Paper
//
//  Created by CHENGJUN LU on 7/1/18.
//  Copyright © 2018 CHENGJUN LU. All rights reserved.
//

    // let colorArray = ["Black","Brown","Gray","Green","Blue","Orange","Purple","Yellow","Red","Pink","LGreen","LBlue"]

import UIKit

class ScratchPaperViewController:UIViewController {

    @IBOutlet weak var paperView: ScratchPaperView!
    
    @IBOutlet weak var toolBarView: UIView!
    
    
    
    @IBOutlet weak var ColorBrushOpcityPanel: UIView!
    
    @IBOutlet weak var BrushLabel: UILabel!
    @IBOutlet weak var OpacityLabel: UILabel!
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    
    @IBAction func BrushSlider(_ sender: UISlider) {
       
        numBrushChange()
        brushLabelChange()
        
//        sender addTarget:self action:@selector(sliderReleasedMethod:) forControlEvents:UIControlEventTouchUpInside
        
        
    }
    
    @IBAction func OpacitySlider(_ sender: UISlider) {
        
        numOpacityChange()
        opacityLableChange()
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       ColorBrushOpcityPanel.isHidden = true
        
       
        paperView.loadDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
        
        print("viewDid load get called")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func penButtomPressed(_ sender: UIButton) {
        
        ColorBrushOpcityPanel.isHidden = !ColorBrushOpcityPanel.isHidden
    
        attribute.instance.colorPanelIsEnable = !attribute.instance.colorPanelIsEnable 
    }
    
 

    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        
        deleteDrawingContext()
        
    }
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        
        attribute.instance.colorIndex = sender.tag
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.ColorBrushOpcityPanel.isHidden = true
            attribute.instance.colorPanelIsEnable = false
        }
        
        
    
    }
  
  
  
    
    func deleteDrawingContext(){
        
        
        for drawContext in paperView.drawContextArray{
            
            paperView.context.delete(drawContext)
            
        }
        
        paperView.saveDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
        
    }

   
    
    
    func numBrushChange() {
        
        attribute.instance.numBrush = Int16(brushSlider.value)
        
    }
    
    func brushLabelChange(){
        
        BrushLabel.text = "Brush: \(Int(brushSlider.value))"
        
        
    }
    
    func numOpacityChange() {
        
        attribute.instance.numOpacity = opacitySlider.value
        
    }
    
    func opacityLableChange() {
        
        OpacityLabel.text = "Opacity: " + String(format: "%.1f", opacitySlider.value)
        
    }
    
//    override func viewDidLayoutSubviews() {
//        print("I can call in subview")
//    }
  
    func rentrunToDrawingView(){
        ColorBrushOpcityPanel.isHidden = true
        attribute.instance.colorPanelIsEnable = false
    }
    
   
    
    
    
    



}

