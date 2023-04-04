//
//  ImageProcessingService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import Foundation
import UIKit

final class ImageProcessingService {
    
    static let shared = ImageProcessingService()
    
    func process(image: UIImage, aspectRatio: CGFloat) -> UIImage {
        
        print("Aspect Ratio of Frame is: \(aspectRatio)")
        
        let imageAspectRatio = image.size.width / image.size.height
        
        print("Aspect Ratio of Image is: \(imageAspectRatio)")
        
        var newImageWidth: Double
        var newImageHeight: Double
        
        if aspectRatio > imageAspectRatio {
            newImageWidth = image.size.height * aspectRatio
            newImageHeight = image.size.height
        } else {
            newImageWidth = image.size.width
            newImageHeight = image.size.width / aspectRatio
        }
        
        print("The image should be width: \(newImageWidth) and height \(newImageHeight)")
        
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)
        
        UIGraphicsBeginImageContext(newImageSize)
        
        UIColor.white.setFill()
        
        UIRectFill(CGRect(origin: .zero, size: newImageSize))
        
        let matScale = 0.8
        
        let scaledImageWidth = image.size.width * matScale
        let scaledImageHeight = image.size.height * matScale
        
        let imageRect = CGRect(x: (newImageSize.width - scaledImageWidth) / 2, y: (newImageSize.height - scaledImageHeight) / 2, width: scaledImageWidth, height: scaledImageHeight)
        
//        let imageRect = CGRect(x: (newImageSize.width - image.size.width) / 2, y: (newImageSize.height - image.size.height) / 2, width: image.size.width, height: image.size.height)
    
        image.draw(in: imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}
