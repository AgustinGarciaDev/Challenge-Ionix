//
//  Color+Extension.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit

extension UIColor {
    static func gradientColor(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        return UIColor(patternImage: UIImage(cgImage: cgImage))
    }
}



