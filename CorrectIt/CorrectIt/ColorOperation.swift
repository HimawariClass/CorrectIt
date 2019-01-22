//
//  Color.swift
//  CorrectIt
//
//  Created by Taillook on 2018/12/07.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import Foundation
import UIKit

class ColorOperation {
    func getColorDifference( rgb1: [Int], rgb2: [Int]) -> Int {
        if (rgb1.count == 3 && rgb2.count == 3) {
            let difr = abs(rgb1[0] - rgb2[0])
            let difg = abs(rgb1[1] - rgb2[1])
            let difb = abs(rgb1[2] - rgb2[2])
            return Int((difr + difg + difb) / 3)
        } else {
            return 1000
        }
    }
    
    func getRGBFromHEX(hex: String) -> [Int] {
        var hexStr = hex
        hexStr.replaceSubrange(hexStr.range(of: "#")!, with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            return [r,g,b]
        } else {
            return [0,0,0]
        }
    }
}
