//
//  Vector3DTests.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 30/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import XCTest

class Vector3DTests: XCTestCase {
    
    let accuracy = 2.0
    
    //MARK: getAngle tests
    func testGetAngle0() {
        let angle = Vector3D.getAngle(x: 1, y: 0)
        XCTAssertEqualWithAccuracy(0, angle, accuracy: accuracy)
    }
    
    func testGetAngle45() {
        let angle = Vector3D.getAngle(x: 1, y: 1)
        XCTAssertEqualWithAccuracy(45, angle, accuracy: accuracy)
    }
    
    func testGetAngle90() {
        let angle = Vector3D.getAngle(x: 0, y: 1)
        XCTAssertEqualWithAccuracy(90, angle, accuracy: accuracy)
    }
    
    func testGetAngle135() {
        let angle = Vector3D.getAngle(x: -1, y: 1)
        XCTAssertEqualWithAccuracy(135, angle, accuracy: accuracy)
    }
    
    func testGetAngle180() {
        let angle = Vector3D.getAngle(x: -1, y: 0)
        XCTAssertEqualWithAccuracy(180, angle, accuracy: accuracy)
    }
    
    func testGetAngle225() {
        let angle = Vector3D.getAngle(x: -1, y: -1)
        XCTAssertEqualWithAccuracy(225, angle, accuracy: accuracy)
    }
    
    func testGetAngle270() {
        let angle = Vector3D.getAngle(x: 0, y: -1)
        XCTAssertEqualWithAccuracy(270, angle, accuracy: accuracy)
    }
    
    func testGetAngle315() {
        let angle = Vector3D.getAngle(x: 1, y: -1)
        XCTAssertEqualWithAccuracy(315, angle, accuracy: accuracy)
    }
    
    
}
