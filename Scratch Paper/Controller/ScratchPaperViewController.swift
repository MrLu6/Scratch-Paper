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
        
    }
    
    @IBAction func OpacitySlider(_ sender: UISlider) {
        
        numOpacityChange()
        opacityLableChange()
        
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ColorBrushOpcityPanel.isHidden = true
        paperView.loadDrawingContext()
        paperView.loadTochBeginPoint()
        paperView.loadTochEndPoint()
        paperView.resetDrawContextBeforeTerminated()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func penButtomPressed(_ sender: UIButton) {
        
        ColorBrushOpcityPanel.isHidden = !ColorBrushOpcityPanel.isHidden
    
        attribute.instance.colorPanelIsEnable = !attribute.instance.colorPanelIsEnable
        
        attribute.instance.eraserEnable = false
    }
    
    
    @IBAction func unDoButtomPressed(_ sender: UIButton) {
        
        paperView.undo()
        
    }
    
   
    @IBAction func reDoButtomPrssed(_ sender: Any) {
        
        paperView.redo()
        
    }
    
 
    @IBAction func eraserButtonPressed(_ sender: Any) {
        
        attribute.instance.eraserEnable = !attribute.instance.eraserEnable
        attribute.instance.colorPanelIsEnable = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ColorBrushOpcityPanel.isHidden = true

        }
      
    }
    
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        if !paperView.drawContextArray.isEmpty {
        
            let alert = UIAlertController(title: "Do you want to clear all drawed Context?", message: "You will not be able to recovert any drawed Context", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                self.paperView.deleteDrawingContext()
            }
            
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alert, animated: true)
        }
        
        
        rentrunToDrawingView()
        
    }
    
    
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        
        attribute.instance.colorIndex = sender.tag
        attribute.instance.colorPanelIsEnable = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ColorBrushOpcityPanel.isHidden = true
            
        }
        
    }
  
  
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        let currentDrawContextImage = paperView.asImage()
        
        let activityVC = UIActivityViewController(activityItems: [currentDrawContextImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = paperView
        self.present(activityVC, animated: true, completion: nil)
        
        
        
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
    
    func rentrunToDrawingView(){
        ColorBrushOpcityPanel.isHidden = true
        attribute.instance.colorPanelIsEnable = false
    }
    

}

