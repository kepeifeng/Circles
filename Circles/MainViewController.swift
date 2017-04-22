//
//  MainViewController.swift
//  Circles
//
//  Created by Kent Peifeng Ke on 2017/4/16.
//  Copyright © 2017年 Kent Peifeng Ke. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var drawingBoard: DrawingBoard!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addOne(_ sender: Any) {
        
        drawingBoard.fillOneMore()
        drawingBoard.needsDisplay = true
    }
}
