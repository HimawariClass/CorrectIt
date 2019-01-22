//
//  Color.swift
//  CorrectIt
//
//  Created by Taillook on 2018/12/07.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import Foundation

class ColorOperation {
    func getColorDifference( rgb1: [Int], rgb2: [Int]) -> Bool {
        if (rgb1.count == 3 && rgb2.count == 3) {
            let difr = abs(rgb1[0] - rgb2[0])
            let difg = abs(rgb1[1] - rgb2[1])
            let difb = abs(rgb1[2] - rgb2[2])
            if Int((difr + difg + difb) / 3) < 10 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getRGBFromHEX(hex: String) -> [Int] {
        var hexStr = hex
        hexStr.replaceSubrange(hexStr.range(of: "#")!, with: "")
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = Int(Float(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0)
        let g = Int(Float(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0)
        let b = Int(Float(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0)
        return [r,g,b]
    }
}
