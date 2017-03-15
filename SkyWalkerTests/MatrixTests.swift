//
//  Matrix.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import XCTest

class MatrixTests: XCTestCase {
    
    /*
        Constructors
    */
    func testInitWithData () {
        let data: [[Double]] = [[1,1],
                                [1,1]]
        
        let matrix = Matrix(data: data)
        
        for i in 0..<data.count {
            for j in 0..<data[0].count {
                XCTAssertEqual(data[i][j], matrix[i, j])
            }
        }
        
    }
    
    
    /*
        Multiply
    */
    func testMultiply3x3 () {
        let data1: [[Double]] = [
            [1,2,3],
            [4,5,6],
            [7,8,9]]
        let data2: [[Double]] = [
            [9,8,7],
            [6,5,4],
            [3,2,1]]
        let expected: [[Double]] = [
            [30,24,18],
            [84,69,54],
            [138,114,90]]
        
        let matrix1 = Matrix(data: data1)
        let matrix2 = Matrix(data: data2)
        let result = try! matrix1 * matrix2
        
        for i in 0..<expected.count {
            for j in 0..<expected[0].count {
                XCTAssertEqual(expected[i][j], result[i, j])
            }
        }

    }
    
    func testMultiplyInvalidSize () {
        
        let data1: [[Double]] = [[1,2,3]]
        let data2: [[Double]] = [[9,8,7]]
        
        let matrix1 = Matrix(data: data1)
        let matrix2 = Matrix(data: data2)
        
        do {
            _ = try matrix1 * matrix2
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(true)
        }
        
    }
}
