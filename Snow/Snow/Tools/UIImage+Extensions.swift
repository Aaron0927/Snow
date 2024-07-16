//
//  UIImage+Extensions.swift
//  Snow
//
//  Created by kim on 2024/7/16.
//

import UIKit

extension UIImage {
    convenience init(size: CGSize, color: UIColor, scale: CGFloat = UIScreen.main.scale) {
        let renderer = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat.default())
        let image = renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        guard let cgImage = image.cgImage else {
            fatalError("Failed to create CGImage from UIImage")
        }
        self.init(cgImage: cgImage, scale: scale, orientation: .up)
    }
}


