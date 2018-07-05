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
    
    @IBOutlet weak var coloBrushOpcityPanel: UIView!
    
    @IBOutlet weak var BrushLabel: UILabel!
    @IBOutlet weak var OpacityLabel: UILabel!
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    
    @IBAction func BrushSlider(_ sender: UISlider) {
       
        numBrushChange()
        brushLabelChange()
        
    }
    
    @IBAction func OpacitySlider(_ sender: UISlider) {
        
        numOpacityChange()
        opacityLableChange()
        
    }
    

        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coloBrushOpcityPanel.isHidden = true
        
        paperView.layer.zPosition = 1
        toolBarView.layer.zPosition = 2
        coloBrushOpcityPanel.layer.zPosition = 3
        
        
        paperView.loadDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func penButtomPressed(_ sender: UIButton) {
//        
        coloBrushOpcityPanel.isHidden = attribute.instance.colorPanelIsEnable
        
       
        
//        paperView.isUserInteractionEnabled = false
        
        
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        deleteDrawingContext()
        
    }
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        
        attribute.instance.colorIndex = sender.tag
    
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
    
    
  
    
   
    
    
    
    



}

