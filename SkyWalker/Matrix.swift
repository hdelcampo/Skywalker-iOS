//
//  Matrix.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 Mathematical matrix of doubles representation
 */
class Matrix {
    
    enum MathError: Error {
        case INVALID_SIZES
    }
    
    /**
        Number of rows and cols
    */
    let rows: Int,
        cols: Int
    
    /**
        Data of the matrix
    */
    var data: [[Double]]
    
    /**
        Returns the asked data.
        - Parameters:
            - row: The data row.
            - col: The data col:
        - Returns: The asked data.
    */
    subscript(row: Int, col: Int) -> Double {
        get {
            return data[row][col]
        }
        
        set(newValue) {
            data[row][col] = newValue
        }
    }
    
    /**
     Constructs a new matrix with the sizes and fulled with 0s.
        - Parameters:
            - rows: The number of rows.
            - cols: The number of columns.
     */
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        data = [[Double]](repeating:[Double](repeating: 0, count: cols), count: rows)
    }
    
    /**
        Constructs a new matrix with the given values
        - Parameter data: The data to represent
    */
    init(data: [[Double]]) {
        self.data = data
        rows = data.count
        cols = data[0].count
    }
    
    /**
        Multiplies one matrix by another.
        - Parameters:
            - left: left side of the multiplication.
            - right: right side of the multiplication.
        - Throws: `MathError.INVALID_SIZES`if cannot multiply those matrix.
        - Returns: A new matrix as a result of the multiplication.
    */
    static func * (left: Matrix, right: Matrix) throws -> Matrix {
        
        if (left.cols != right.rows) {
            throw MathError.INVALID_SIZES
        }
        
        var result = [[Double]](repeating: [Double](repeating: 0, count: right.cols), count: left.rows)
        
        for i in 0..<left.rows {
            for j in 0..<right.cols {
                for k in 0..<left.cols {
                    result[i][j] += left.data[i][k] * right.data[k][j]
                }
            }
        }
        
        return Matrix(data: result)
    
    }
    
}
