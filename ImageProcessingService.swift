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
                
        var workingImage = image
        
        let imageAspectRatio = workingImage.size.width / workingImage.size.height
        
        if imageAspectRatio >= 1, let cgImage = workingImage.cgImage {
            workingImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .left)
        }
                
        var newImageWidth: Double
        var newImageHeight: Double
        
        if aspectRatio > imageAspectRatio {
            newImageWidth = workingImage.size.height * aspectRatio
            newImageHeight = workingImage.size.height
        } else {
            newImageWidth = workingImage.size.width
            newImageHeight = workingImage.size.width / aspectRatio
        }

        print("The image should be width: \(newImageWidth) and height \(newImageHeight)")
        
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)
        
        UIGraphicsBeginImageContext(newImageSize)
        
        UIColor.white.setFill()
        
        UIRectFill(CGRect(origin: .zero, size: newImageSize))
        
        let matScale = 0.8
        
        let scaledImageWidth = workingImage.size.width * matScale
        let scaledImageHeight = workingImage.size.height * matScale
        
        let imageRect = CGRect(x: (newImageSize.width - scaledImageWidth) / 2, y: (newImageSize.height - scaledImageHeight) / 2, width: scaledImageWidth, height: scaledImageHeight)
            
        workingImage.draw(in: imageRect)
        
        let newImageData = UIGraphicsGetImageFromCurrentImageContext()!.jpegData(compressionQuality: 0.5)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: newImageData) ?? UIImage()
                
    }
    
}
