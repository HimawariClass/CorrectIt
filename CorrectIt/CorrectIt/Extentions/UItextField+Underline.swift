//
//  UItextField+Underline.swift
//  CorrectIt
//
//  Created by Taillook on 2018/09/27.
//  Copyright © 2018 HimawariClass. All rights reserved.
//
import UIKit

extension UITextField {
    func addUnderline(width: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
