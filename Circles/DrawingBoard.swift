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

    private var _needsUpdate = true
    private var _rect:CGRect = .zero
    
    
    var x:CGFloat = 0.0{
        didSet{
            _needsUpdate = true
        }
    }
    var y:CGFloat = 0.0{
        didSet{
            _needsUpdate = true
        }
    }
    var radius:CGFloat = 0.0{
        didSet{
            _needsUpdate = true
        }
    }
    
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
        if self.rect.intersects(circle2.rect) == true {
            return (farFrom(circle2: circle2) < (radius + circle2.radius))
        }
        return false
        
    }
    
    var area:CGFloat{
        get{
            return .pi * (pow(radius, 2))
        }
    }
    
    var rect:CGRect{
        get{

            if _needsUpdate {
                _rect = CGRect(x: x - radius, y: y - radius, width: radius*2, height: radius*2)
                _needsUpdate = false
            }
            
            return _rect
        }
    }
}

typealias GridDictionary = [String:NSMutableArray]

class DrawingBoard: NSView {

    override var isFlipped: Bool{get{return true}}
    
    var circlesGrid = GridDictionary()
    
    var circles = [Circle]()
    
    var gridPoint:CGPoint?
    
    let shape:Circle = Circle(x: 1000, y: 1000, radius: 1000)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.yellow.setFill()
//        NSGraphicsContext.current()
        NSBezierPath(rect: dirtyRect).fill()

        NSColor.red.setStroke()
//        Color.red.setStore()
        
        let path = NSBezierPath()
        for (index, circle) in circles.enumerated() {
        
//            if index == circles.count - 1 {
//                NSColor.blue.setStroke()
//            }
            
            path.appendOval(in: circle.rect.insetBy(dx: 1, dy: 1))
            
//            let path = NSBezierPath(ovalIn: circle.rect)
//            path.stroke()
        }
        path.stroke()
        
        
        
        NSColor.blue.setStroke()
        if let gridPoint = gridPoint {
        
            let line1 = NSBezierPath()
            line1.move(to: NSPoint(x: gridPoint.x, y: 0))
            line1.line(to: NSPoint(x: gridPoint.x, y: frame.height))
         
            line1.stroke()
            
            let line2 = NSBezierPath()
            line2.move(to: NSPoint(x: 0, y: gridPoint.y))
            line2.line(to: NSPoint(x: frame.width, y: gridPoint.y))
            
            line2.stroke()
            
        }
        
    }
    
    var fromBottom = false
    
    func fill(complete:@escaping ()->()) {
        
//        circles = [Circle]()
        reset()
        
        DispatchQueue.global(qos: .background).async {
            let startTime = NSDate.timeIntervalSinceReferenceDate
            self.fillInBackground()
            let endTime = NSDate.timeIntervalSinceReferenceDate
            
            Swift.print("耗时:\(endTime - startTime)秒")
            
            DispatchQueue.main.sync {
                self.needsDisplay = true
                complete()
            }
        }
    }
    
    func fillInBackground(){
    
        var failedCount = 0
        var area:CGFloat = 0
        
        let startTime = NSDate.timeIntervalSinceReferenceDate
        
        for gridStep in 1 ... 4 {
        
            gridPoint = CGPoint(x: frame.width * CGFloat(gridStep) / 4, y: frame.height * CGFloat(gridStep) / 4)
        
//        gridPoint = CGPoint(x: frame.width, y: frame.height)
            failedCount = 0
            while failedCount < 1000 {
                if fillOneMore(gridPoint!.x, gridPoint!.y) == false {
                    failedCount += 1
                }else{
                    failedCount = 0
                    
                    let lastCircle = circles.last!
                    area += lastCircle.area
                    
                    if(circles.count % 10 == 0){
                        
//                        gridPoint = CGPoint(x: lastCircle.x, y: lastCircle.y)

                        DispatchQueue.main.sync {
                            self.needsDisplay = true
                            let currentTime = NSDate.timeIntervalSinceReferenceDate
                            
                            Swift.print("数量:\(circles.count)每个圆平均耗时:\((currentTime - startTime) / TimeInterval(circles.count))")
                        }
                        
                    }
                    
                }
            }
    
        }
        
        
        
        let rate = area / (frame.width * frame.height)
        Swift.print("面积比:\(rate)")
    }
    
    func reset(){
    
        circles = [Circle]()
        circlesGrid = GridDictionary()
    }
    
    func addCircle(_ circle:Circle) {
        
        circles.append(circle)
        gridsForCircle(circle).forEach { (key, value) in
            value.add(circle)
        }
        
    }
    
    func gridsForCircle(_ circle:Circle) -> GridDictionary{
    
        
        let rect = circle.rect
        
        var gridKeys = [String]()
        
        var grids = GridDictionary()
        var keys = ["\(Int(rect.minX) / 100),\(Int(rect.minY) / 100)",
            "\(Int(rect.minX) / 100),\(Int(rect.maxY) / 100)",
            "\(Int(rect.maxX) / 100),\(Int(rect.minY) / 100)",
            "\(Int(rect.maxX) / 100),\(Int(rect.maxY) / 100)"]

        for key in keys {
            
            if gridKeys.contains(key) == false {
                gridKeys.append(key)
                grids[key] = gridForKey(key)
            }
        }
        
        return grids
        
        
        
    }
    
    func gridForKey(_ key:String) -> NSMutableArray{
        
        var grid = circlesGrid[key]
        if grid == nil{
            grid = NSMutableArray()
            circlesGrid[key] = grid
        }
        return grid!
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
        
        let point = self.convert(event.locationInWindow, from: self.window?.contentView)
        
        if fillOneMore(point.x, point.y) {
            self.needsDisplay = true
        }
        Swift.print("mouseUp:\(event)\n\(event.locationInWindow)")
        Swift.print("point:\(point)")
    }
    
    func fillOneMore(_ basicX:CGFloat,_ basicY:CGFloat) -> Bool {
        
        let MaxRadius:UInt32 = 20
        let MinRadius:UInt32 = 5
        
        
        
        var x:CGFloat = 0, y:CGFloat = 0
        
//        let radiusSet:[CGFloat] = [100,100,50,50,50,50,25,25,25,25,25,25,25,25]
//        let radiusSet:[CGFloat] = [40,20,20,20,20,10,10,10,10,10,10,10,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5]
//        let radius = CGFloat(arc4random_uniform(MaxRadius - MinRadius) + MinRadius)
//        let radius = radiusSet[Int(arc4random_uniform(UInt32(radiusSet.count - 1)))]
        
        let number = arc4random_uniform(1+2+3+4+5+6)
        var radius:CGFloat
        if number <= 1 {
            radius = 40
        }else if number < 1+2 {
            radius = 32
        }else if number < 1+2+3{
            radius = 25
        }else if number < 1+2+3+4 {
            radius = 20
        }else if number < 1+2+3+4+5{
            radius = 16
        }else{
            radius = 13
        }
//        radius = 10
//        fromBottom = !fromBottom
        
        let d = radius*2
//        if fromBottom {
//            x = CGFloat(arc4random_uniform(UInt32(basicX - radius))) + radius
//            y = basicY - radius
//        }else{
//
//            x = basicX - radius
//            y = CGFloat(arc4random_uniform(UInt32(basicY - radius))) + radius
//        }
//        

        let shapeRadius:CGFloat = 1000.0
        let r2 = shapeRadius - radius
        let a = CGFloat(arc4random_uniform(UInt32(shapeRadius)))
        x = (shapeRadius + a) + radius
        y = shapeRadius + sqrt(pow(shapeRadius, 2) - pow(a, 2)) + radius
        
        var newCircle = Circle(x: x, y: y, radius: radius)
        
        var bestDeltaX:CGFloat, bestDeltaY:CGFloat, bestDistance:CGFloat

        var deltaX:CGFloat = 0, deltaY:CGFloat = 0
        
        
        
        let stepsOne:[CGFloat] = [400,-400,198,-198,96,-96,41,-41,18,-18,9,-9,4,-2,1]
        let stepsTwo:[CGFloat] = [400,200,100,45,20,9,4,1]
        if fromBottom  {

            (bestDeltaX,bestDeltaY) = moveXFirst(circle: newCircle, stepsOne: stepsOne, stepsTwo: stepsTwo)
            (deltaX,deltaY) = moveYFirst(circle: newCircle, stepsOne: stepsOne, stepsTwo: stepsTwo)
        }else{
            (bestDeltaX,bestDeltaY) = moveYFirst(circle: newCircle, stepsOne: stepsOne, stepsTwo: stepsTwo)
            (deltaX,deltaY) = moveXFirst(circle: newCircle, stepsOne: stepsOne, stepsTwo: stepsTwo)

        
        }
        

        
//        if pow(deltaX,2)+pow(deltaY,2) > pow(bestDeltaX,2)+pow(bestDeltaY,2) {
//            bestDeltaX = deltaX
//            bestDeltaY = deltaY
//        }
 
 
        newCircle.x -= bestDeltaX
        newCircle.y -= bestDeltaY
        
        
        if bounds.contains(newCircle.rect) && isValidCircle(newCircle){

//            circles.append(newCircle)
            addCircle(newCircle)
            return true
        }
        
        return false
        
    }
    
    
    func moveXFirst(circle:Circle, stepsOne:[CGFloat], stepsTwo:[CGFloat]) -> (deltaX:CGFloat, deltaY:CGFloat) {
        
        var deltaX:CGFloat = 0, deltaY:CGFloat = 0
        
        let x:CGFloat = circle.x, y:CGFloat = circle.y
        let radius = circle.radius
        
        var stepXIndex = 0
        while(stepXIndex < stepsOne.count) {
            let stepX = stepsOne[stepXIndex]
            
            if isValidCircle(Circle(x: x-(deltaX+stepX), y: y-deltaY, radius: radius)){
                deltaX += stepX
                //                    canYMove = true
                stepXIndex -= 1
            }else{
                //                    canXMove = false
            }
            stepXIndex += 1
            
            var stepIndex = 0
            while(stepIndex < stepsTwo.count) {
                let stepY = stepsTwo[stepIndex]
                if isValidCircle(Circle(x: x-deltaX, y: y-deltaY-stepY, radius: radius)){
                    deltaY += stepY
                    //                        canXMove = true
                    stepIndex -= 1
                    stepXIndex = 0
                }else{
                    //                        canYMove = false
                }
                stepIndex += 1
            }
        }
        
        return (deltaX, deltaY)
    }
    
    func moveYFirst(circle:Circle, stepsOne:[CGFloat], stepsTwo:[CGFloat]) -> (deltaX:CGFloat, deltaY:CGFloat) {
        
        var deltaX:CGFloat = 0, deltaY:CGFloat = 0
        
        let x:CGFloat = circle.x, y:CGFloat = circle.y
        let radius = circle.radius
        
        var stepYIndex = 0
        while(stepYIndex < stepsOne.count) {
            let stepY = stepsOne[stepYIndex]
            if isValidCircle(Circle(x: x-deltaX, y: y-deltaY-stepY, radius: radius)){
                deltaY += stepY
                //                    canXMove = true
                
                stepYIndex -= 1
            }else{
                //                    canYMove = false
                
                
            }
            stepYIndex += 1
            
            var stepXIndex = 0
            while(stepXIndex < stepsTwo.count) {
                let stepX = stepsTwo[stepXIndex]
                
                if isValidCircle(Circle(x: x-(deltaX+stepX), y: y-deltaY, radius: radius)){
                    deltaX += stepX
                    //                        canYMove = true
                    stepXIndex -= 1
                    stepYIndex = 0
                }else{
                    //                        canXMove = false
                }
                stepXIndex += 1
            }
        }
        
        return (deltaX, deltaY)
    }
    
    
    func isValidCircle(_ circle:Circle)->Bool{
    
//        if(circle.x < circle.radius || circle.y < circle.radius || (circle.x + circle.radius) > bounds.width || circle.y + circle.radius > bounds.height){
//            return false
//        }
        
        if (circle.farFrom(circle2: shape) > shape.radius - circle.radius){
            return false
        }
        
        return (isCircleOverlapped(circle) == false)
    
    }
    
    func isCircleOverlapped(_ circle1:Circle, skipIndex:Int? = nil) -> Bool {
        
        
        
        if circles.count == 0 {
            return false
        }
        
        
        let grids = gridsForCircle(circle1)
        
        for circleSet in grids.values {
            
            if circleSet.count == 0 {
                continue
            }
            
            
            for index in 0 ... circleSet.count - 1{
                if(index == skipIndex){
                    continue
                }
                
                let circle2 = circleSet[index] as! Circle
                
                if circle1.isOverlaaped(circle2) {
                    return true
                }
                
            }
            
        }
        
        
        return false
    }
}
