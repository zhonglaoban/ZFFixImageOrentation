//
//  UIImageExtension.swift
//  ZFFixImageOrentation
//
//  Created by 钟凡 on 2020/11/23.
//

import UIKit

extension UIImage {
    enum RotateDegree: Int {
        case angle_0
        case angle_90
        case angle_180
        case angle_270
    }
    func fiexdOrientation() -> UIImage {
    var degree:RotateDegree = .angle_0
    let orientation = imageOrientation
    switch orientation {
        case .down:
            degree = .angle_180
        case .left:
            degree = .angle_270
        case .right:
            degree = .angle_90
        default:
            break
    }
        return rotate(to: degree)
    }
    func rotate(to degree: RotateDegree) -> UIImage {
        var rotatedSize = size
        var angle:CGFloat = 0
        switch degree {
            case .angle_0:
                rotatedSize = size
            case .angle_90:
                angle = CGFloat.pi * 0.5
                rotatedSize = CGSize(width: size.height, height: size.width)
            case .angle_180:
                angle = CGFloat.pi
                rotatedSize = size
            case .angle_270:
                angle = -CGFloat.pi * 0.5
                rotatedSize = CGSize(width: size.height, height: size.width)
        }
        
        UIGraphicsBeginImageContext(rotatedSize)
        
        let bitmap = UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap?.rotate(by: angle)
        var scaleX:CGFloat = 1
        var scaleY:CGFloat = 1
        if rotatedSize.width > 0 {
            scaleX = size.width / rotatedSize.width
        }
        if rotatedSize.height > 0 {
            scaleY = size.height / rotatedSize.height
        }
        bitmap?.scaleBy(x: scaleX, y: -scaleY)
        
        let origin = CGPoint(x: -rotatedSize.width / 2, y: -rotatedSize.height / 2)
        bitmap?.draw(cgImage!, in: CGRect(origin: origin, size: rotatedSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
