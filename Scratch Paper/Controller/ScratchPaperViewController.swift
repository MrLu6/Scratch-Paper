//
//  ViewController.swift
//  Scratch Paper
//
//  Created by CHENGJUN LU on 7/1/18.
//  Copyright © 2018 CHENGJUN LU. All rights reserved.
//

import UIKit

class ScratchPaperViewController:UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var paperView: ScratchPaperView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDrawingContext()
        // Do any additional setup after loading the view, typically from a nib.\
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //self.setNeedsDisplay()
  
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        
       deleteDrawingContext()
        
        
        
    }
    
    
    func loadDrawingContext(){
        paperView.loadDrawingContext()
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
    }
    
    func deleteDrawingContext(){
        
        while !paperView.drawContextArray.isEmpty {
            paperView.drawContextArray.popLast()
        }
        paperView.draw(CGRect(x: 0, y: 0, width: paperView.frame.width, height: paperView.frame.height))
        paperView.setNeedsDisplay()
        
    }
    



}

