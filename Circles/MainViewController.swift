//
//  MainViewController.swift
//  Circles
//
//  Created by Kent Peifeng Ke on 2017/4/16.
//  Copyright © 2017年 Kent Peifeng Ke. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var inidicator: NSProgressIndicator!
    @IBOutlet weak var drawingBoard: DrawingBoard!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
//        drawingBoard.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView?.frame.size = CGSize(width: 2000, height: 2000)
        Swift.print("documentView:\(scrollView.contentSize)")
//        scrollView.contentSize = drawingBoard.frame.size
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        Swift.print("[viewDidLayout]documentView:\(scrollView.contentSize)")
        
    }
    
    @IBAction func generate(_ sender: Any) {
        
        self.inidicator.startAnimation(nil)
        
        drawingBoard.fill(){
        
            self.inidicator.stopAnimation(nil)
            
        }
        
    }
    @IBAction func addOne(_ sender: Any) {
        
        drawingBoard.fillOneMore(drawingBoard.frame.width, drawingBoard.frame.height)
        drawingBoard.needsDisplay = true
    }
}
