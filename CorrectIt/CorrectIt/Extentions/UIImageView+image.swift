//
//  UIImageView+image.swift
//  CorrectIt
//
//  Created by Taillook on 2018/12/15.
//  Copyright © 2018 HimawariClass. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private var aspectFitSize: CGSize? {
        get {
            guard let aspectRatio = image?.size else { return nil }
            let widthRatio = bounds.width / aspectRatio.width
            let heightRatio = bounds.height / aspectRatio.height
            let ratio = (widthRatio > heightRatio) ? heightRatio : widthRatio
            let resizedWidth = aspectRatio.width * ratio
            let resizedHeight = aspectRatio.height * ratio
            let aspectFitSize = CGSize(width: resizedWidth, height: resizedHeight)
            return aspectFitSize
        }
    }
    
    var aspectFitFrame: CGRect? {
        get {
            guard let size = aspectFitSize else { return nil }
            return CGRect(origin: CGPoint(x: frame.origin.x + (bounds.size.width - size.width) * 0.5, y: frame.origin.y + (bounds.size.height - size.height) * 0.5), size: size)
        }
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let img = renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        return img
    }
}
