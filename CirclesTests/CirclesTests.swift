//
//  CirclesTests.swift
//  CirclesTests
//
//  Created by Kent Peifeng Ke on 2017/4/16.
//  Copyright © 2017年 Kent Peifeng Ke. All rights reserved.
//

import XCTest
@testable import Circles

class CirclesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testGrid(){
    
        let board = DrawingBoard()
        let circle = Circle(x: 20, y: 15, radius: 20)
        var grids = board.gridsForCircle(circle)
        print(grids.keys)
        
        
        circle.x = 100
        circle.y = 150
        circle.radius = 45
        grids = board.gridsForCircle(circle)
        print(grids.keys)
        
        
        circle.x = 450
        circle.y = 150
        circle.radius = 45
        grids = board.gridsForCircle(circle)
        print(grids.keys)
        
    
    }
}
