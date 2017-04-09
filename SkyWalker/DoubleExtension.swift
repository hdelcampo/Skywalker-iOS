//
//  DoubleExtension.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation
import GLKit

extension Double {
    var toDegrees: Double { return Double(GLKMathRadiansToDegrees(Float(self))) }
    var toRadians: Double { return Double(GLKMathDegreesToRadians(Float(self))) }
}
