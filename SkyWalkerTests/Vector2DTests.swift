//
//  Vector2DTests.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import XCTest

/**
    Vector 2D unit tests.
*/
class Vector2DTests: XCTestCase {
    
    let rotatingAccuracy = 0.0001
    let accuracy = 0.0001
    
    //MARK: Constructors tests
    func testConstructor() {
        let x = 1.0, y = 2.0
        let vector = Vector2D(x: x, y: y)
        XCTAssertEqual(x, vector.x)
        XCTAssertEqual(y, vector.y)
    }
    
    //MARK: Normalize tests
    func testNormalize() {
        var vector = Vector2D(x: 1, y: 1)
        vector.normalize()
        XCTAssertEqual(1/sqrt(2), vector.x)
        XCTAssertEqual(1/sqrt(2), vector.y)
    }
    
    //MARK: Dot product tests
    func testDot() {
        let v1 = Vector2D(x: 2, y: -3)
        let v2 = Vector2D(x: -4, y: 2)
        XCTAssertEqual(-14, v1*v2)
    }
    
    //MARK: Angle product tests
    func testAngle0() {
        let v1 = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 1, y: 0)
        XCTAssertEqual(0, v1.angle(v: v2))
    }
    
    func testAngle90() {
        let v1 = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 0, y: -1)
        XCTAssertEqual(90, v1.angle(v: v2))
    }
    
    func testAngle180() {
        let v1 = Vector2D(x: 0, y: -1)
        let v2 = Vector2D(x: 0, y: 1)
        XCTAssertEqual(180, v1.angle(v: v2))
    }
    
    func testAngle270() {
        let v1 = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 0, y: 1)
        XCTAssertEqual(90, v1.angle(v: v2))
    }
    
    //MARK: Angle with sign tests
    func testAngleSign0() {
        let v = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 1, y: 0)
        XCTAssertEqual(0, v.angleWithSign(v: v2))
    }
    
    func testAngleSign90() {
        let v = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 0, y: -1)
        XCTAssertEqual(90, v.angleWithSign(v: v2))
    }
    
    func testAngleSign180() {
        let v = Vector2D(x: 0, y: -1)
        let v2 = Vector2D(x: 0, y: 1)
        XCTAssertEqual(-180, v.angleWithSign(v: v2))
    }
    
    func testAngleSign270() {
        let v = Vector2D(x: 1, y: 0)
        let v2 = Vector2D(x: 0, y: 1)
        XCTAssertEqual(-90, v.angleWithSign(v: v2))
    }
    
    //MARK: Module tests
    func testModule() {
        let vector = Vector2D(x: 1, y: 1)
        XCTAssertEqual(sqrt(2), vector.module())
    }
    
    func testModuleX() {
        let vector = Vector2D(x: 1, y: 0)
        XCTAssertEqual(1, vector.module())
    }
    
    func testModuleY() {
        let vector = Vector2D(x: 0, y: 1)
        XCTAssertEqual(1, vector.module())
    }
    
    //MARK: Rotate tests
    func testRotate90X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: 90)
        XCTAssertEqualWithAccuracy(0, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(-1, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotate180X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: 180)
        XCTAssertEqualWithAccuracy(-1, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(0, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotate270X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: 270)
        XCTAssertEqualWithAccuracy(0, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(1, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotatemin90X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: -90)
        XCTAssertEqualWithAccuracy(0, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(1, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotatemi180X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: -180)
        XCTAssertEqualWithAccuracy(-1, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(0, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotatemin270X() {
        var vector = Vector2D(x: 1, y: 0)
        vector.rotateClockwise(degrees: -270)
        XCTAssertEqualWithAccuracy(0, vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(-1, vector.y, accuracy: rotatingAccuracy)
    }
    
    func testRotatemin45Y() {
        var vector = Vector2D(x: 0, y: 1)
        vector.rotateClockwise(degrees: 45)
        XCTAssertEqualWithAccuracy(1/sqrt(2), vector.x, accuracy: rotatingAccuracy)
        XCTAssertEqualWithAccuracy(1/sqrt(2), vector.y, accuracy: rotatingAccuracy)
    }
    
    
    //MARK: getAngle tests
    func testGetAngle0() {
        let angle = Vector2D.getAngle(x: 1, y: 0)
        XCTAssertEqualWithAccuracy(0, angle, accuracy: accuracy)
    }
    
    func testGetAngle45() {
        let angle = Vector2D.getAngle(x: 1, y: 1)
        XCTAssertEqualWithAccuracy(45, angle, accuracy: accuracy)
    }
    
    func testGetAngle90() {
        let angle = Vector2D.getAngle(x: 0, y: 1)
        XCTAssertEqualWithAccuracy(90, angle, accuracy: accuracy)
    }
    
    func testGetAngle135() {
        let angle = Vector2D.getAngle(x: -1, y: 1)
        XCTAssertEqualWithAccuracy(135, angle, accuracy: accuracy)
    }
    
    func testGetAngle180() {
        let angle = Vector2D.getAngle(x: -1, y: 0)
        XCTAssertEqualWithAccuracy(180, angle, accuracy: accuracy)
    }
    
    func testGetAngle225() {
        let angle = Vector2D.getAngle(x: -1, y: -1)
        XCTAssertEqualWithAccuracy(225, angle, accuracy: accuracy)
    }
    
    func testGetAngle270() {
        let angle = Vector2D.getAngle(x: 0, y: -1)
        XCTAssertEqualWithAccuracy(270, angle, accuracy: accuracy)
    }
    
    func testGetAngle315() {
        let angle = Vector2D.getAngle(x: 1, y: -1)
        XCTAssertEqualWithAccuracy(315, angle, accuracy: accuracy)
    }
    
}
