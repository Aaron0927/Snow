//
//  UIImage+Extension.swift
//  TGCoreKit
//
//  Created by kim on 2024/8/15.
//

import UIKit

// MARK: - 添加便利构造器
public extension UIImage {
    // 使用color创建图片
    convenience init?(size: CGSize, color: UIColor, scale: CGFloat = UIScreen.main.scale) {
        let renderer = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat.default())
        let image = renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        guard let cgImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage, scale: scale, orientation: .up)
    }
}

// MARK: - 编码
public extension UIImage {
    func base64Encode() -> String {
        var imageData: Data!
        var mimeType: String!
        let info = self.cgImage?.alphaInfo
        let hasAlpha = (info == .first || info == .last || info == .premultipliedFirst || info == .premultipliedLast)
        if hasAlpha {
            imageData = self.pngData()
            mimeType = "image/png"
        } else {
            imageData = self.jpegData(compressionQuality: 1.0)
            mimeType = "image/jpeg"
        }
        return String(format: "data:%@;base64,%@", mimeType, imageData.base64EncodedString())
    }
    
    static func base64Decode(_ str: String) -> UIImage? {
        guard let url = URL(string: str) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
}
