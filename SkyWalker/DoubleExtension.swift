//
//  DoubleExtension.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

extension Double {
    var toDegrees: Double { return self * 180 / .pi }
    var toRadians: Double { return self * .pi / 180 }
}
