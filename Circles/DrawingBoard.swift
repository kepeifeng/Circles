//
//  DrawingBoard.swift
//  Circles
//
//  Created by Kent Peifeng Ke on 2017/4/21.
//  Copyright © 2017年 Kent Peifeng Ke. All rights reserved.
//

import Cocoa

func distance(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) -> CGFloat{
    return sqrt(pow(x2-x1,2)+pow(y2-y1,2))
}

class Circle{

    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var radius:CGFloat = 0.0
    
    init(x:CGFloat, y:CGFloat, radius:CGFloat) {
//        super.init()
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    func farFrom(circle2:Circle) -> CGFloat {
        return distance(x1: x, y1: y, x2: circle2.x, y2: circle2.y)
    }

    func isOverlaaped(_ circle2:Circle) -> Bool{
        return (farFrom(circle2: circle2) < (radius + circle2.radius))
    }
    
    var rect:CGRect{
        get{
            return CGRect(x: x - radius, y: y - radius, width: radius*2, height: radius*2)
        }
    }
}
class DrawingBoard: NSView {

    override var isFlipped: Bool{get{return true}}
    
    var circles = [Circle]()
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.red.setStroke()
//        Color.red.setStore()
        for circle in circles {
        
            let path = NSBezierPath(ovalIn: circle.rect)
            path.stroke()
        }
    }
    
    var fromBottom = false
    func fillOneMore() -> Bool {
        
        let MaxRadius:UInt32 = 100
        let MinRadius:UInt32 = 5
        
        
        var x:CGFloat = 0, y:CGFloat = 0
        let radius = CGFloat(arc4random_uniform(MaxRadius - MinRadius) + MinRadius)
        
        fromBottom = !fromBottom
        
        let d = radius*2
        if fromBottom {
            x = CGFloat(arc4random_uniform(UInt32(frame.width - d))) + d
            y = frame.height - d
        }else{

            x = frame.width - d
            y = CGFloat(arc4random_uniform(UInt32(frame.height - d))) + d
        }
        
        var bestDeltaX:CGFloat, bestDeltaY:CGFloat, bestDistance:CGFloat

        var deltaX:CGFloat = 0, deltaY:CGFloat = 0
        
        
        let steps:[CGFloat] = [100,45,20,9,4,1]
        
        var canXMove = true, canYMove = true
        
        while canXMove || canYMove {
            
            var stepXIndex = 0
            while(stepXIndex < steps.count) {
                let stepX = steps[stepXIndex]
                
                if canXMove && isValidCircle(Circle(x: x-(deltaX+stepX), y: y-deltaY, radius: radius)){
                    deltaX += stepX
                    canYMove = true
                    stepXIndex -= 1
                }else{
                    canXMove = false
                }
                stepXIndex += 1
                
                var stepIndex = 0
                while(stepIndex < steps.count) {
                    let stepY = steps[stepIndex]
                    if canYMove && isValidCircle(Circle(x: x-deltaX, y: y-deltaY-stepY, radius: radius)){
                        deltaY += stepY
                        canXMove = true
                        stepIndex -= 1
                    }else{
                        canYMove = false
                    }
                    stepIndex += 1
                }
            }
        
        }
        
        bestDeltaX = deltaX
        bestDeltaY = deltaY
        
        canXMove = true
        canYMove = true
        deltaX = 0.0
        deltaY = 0.0
        
        while canXMove || canYMove {
            
            var stepYIndex = 0
            while(stepYIndex < steps.count) {
                let stepY = steps[stepYIndex]
                if canYMove && isValidCircle(Circle(x: x-deltaX, y: y-deltaY-stepY, radius: radius)){
                    deltaY += stepY
                    canXMove = true
                    
                    stepYIndex -= 1
                }else{
                    canYMove = false
                    
                    
                }
                stepYIndex += 1
                
                var stepXIndex = 0
                while(stepXIndex < steps.count) {
                    let stepX = steps[stepXIndex]
                    
                    if canXMove && isValidCircle(Circle(x: x-(deltaX+stepX), y: y-deltaY, radius: radius)){
                        deltaX += stepX
                        canYMove = true
                        stepXIndex -= 1
                    }else{
                        canXMove = false
                    }
                    stepXIndex += 1
                }
            }
            
        }
        
        if pow(deltaX,2)+pow(deltaY,2) > pow(bestDeltaX,2)+pow(bestDeltaY,2) {
            bestDeltaX = deltaX
            bestDeltaY = deltaY
        }
        
        let newCircle = Circle(x: x-deltaX, y: y-deltaY, radius: radius)
        if bounds.contains(newCircle.rect){
            circles.append(newCircle)
            return true
        }
        
        return false
        
    }
    
    func isValidCircle(_ circle:Circle)->Bool{
    
        if(circle.x < circle.radius || circle.y < circle.radius){
            return false
        }
        
        return (isCircleOverlapped(circle) == false)
    
    }
    
    func isCircleOverlapped(_ circle1:Circle, skipIndex:Int? = nil) -> Bool {
        
        
        
        if circles.count == 0 {
            return false
        }
        
        for index in 0 ... circles.count - 1{
            if(index == skipIndex){
                continue
            }
            
            let circle2 = circles[index]
            
            if circle1.isOverlaaped(circle2) {
                return true
            }
            
        }
        
        return false
    }
}
