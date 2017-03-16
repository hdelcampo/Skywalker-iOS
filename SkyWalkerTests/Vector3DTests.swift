//
//  Vector3DTests.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 30/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import XCTest

class Vector3DTests: XCTestCase {
    
    let accuracy = 0.0001
    
    //MARK: Constructors tests
    func testInit() {
        let vector = Vector3D(x: 1, y: 2, z: 3)
        XCTAssertEqual(vector.x, 1)
        XCTAssertEqual(vector.y, 2)
        XCTAssertEqual(vector.z, 3)
    }
    
    //MARK: Normalize tests
    func testNormalize() {
        var vector = Vector3D(x: 3, y: 1, z: 2)
        vector.normalize()
        XCTAssertEqualWithAccuracy(vector.x, 0.802, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(vector.y, 0.267, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(vector.z, 0.524, accuracy: 0.1)
    }
    
    func testNormalizeX() {
        var vector = Vector3D(x: 1, y: 0, z: 0)
        vector.normalize()
        XCTAssertEqual(vector.x, 1)
        XCTAssertEqual(vector.y, 0)
        XCTAssertEqual(vector.z, 0)
    }
    
    func testNormalizeY() {
        var vector = Vector3D(x: 0, y: 1, z: 0)
        vector.normalize()
        XCTAssertEqual(vector.x, 0)
        XCTAssertEqual(vector.y, 1)
        XCTAssertEqual(vector.z, 0)
    }
    
    func testNormalizeZ() {
        var vector = Vector3D(x: 0, y: 0, z: 1)
        vector.normalize()
        XCTAssertEqual(vector.x, 0)
        XCTAssertEqual(vector.y, 0)
        XCTAssertEqual(vector.z, 1)
    }
    
    //MARK: Scalar product tests
    func testDot() {
        let v1 = Vector3D(x: 4, y: 8, z: 10)
        let v2 = Vector3D(x: 9, y: 2, z: 7)
        let product = v1 * v2
        XCTAssertEqual(122, product)
    }
    
    //MARK: Angle tests
    func testAngle0() {
        let v1 = Vector3D(x: 1, y: 0, z: 0)
        let v2 = Vector3D(x: 1, y: 0, z: 0)
        XCTAssertEqualWithAccuracy(0, v1.angle(v: v2), accuracy: accuracy)
    }
    
    func testAngle90() {
        let v1 = Vector3D(x: 0, y: 0, z: 1)
        let v2 = Vector3D(x: 0, y: -1, z: 0)
        XCTAssertEqualWithAccuracy(90, v1.angle(v: v2), accuracy: accuracy)
    }
    
    func testAngle180() {
        let v1 = Vector3D(x: 0, y: -1, z: 0)
        let v2 = Vector3D(x: 0, y: 1, z: 0)
        XCTAssertEqualWithAccuracy(180, v1.angle(v: v2), accuracy: accuracy)
    }
    
    //MARK: Module tests
    func testModule() {
        let v = Vector3D(x: 1, y: 1, z: 1)
        XCTAssertEqual(sqrt(3), v.module())
    }
    
    func testModuleX() {
        let v = Vector3D(x: 1, y: 0, z: 0)
        XCTAssertEqual(1, v.module())
    }
    
    func testModuleY() {
        let v = Vector3D(x: 0, y: 1, z: 0)
        XCTAssertEqual(1, v.module())
    }
    
    func testModuleZ() {
        let v = Vector3D(x: 0, y: 0, z: 1)
        XCTAssertEqual(1, v.module())
    }
    
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
