//
//  UIImageExtensions.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 21.11.2023.
//

import UIKit

extension UIImage {
    func withVerticalyFlippedOrientation() -> UIImage {
        var flippedImage = UIImage()
        if let newCGImage = self.cgImage {
            flippedImage = UIImage(cgImage: newCGImage, scale: self.scale, orientation: .downMirrored)
        }
        return flippedImage
    }
}
