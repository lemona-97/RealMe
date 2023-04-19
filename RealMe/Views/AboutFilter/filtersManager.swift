//
//  filters.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import Foundation
import UIKit
import CoreImage


class FilterManager {
    static func returnCIFilter(_ beforeImage: UIImage, _ filterName: Int) -> UIImage {
        switch filterName {
        case 0:
            let context = CIContext()
            let filter = CIFilter(name: "CISepiaTone")!
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            let image = CIImage(image: beforeImage)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return UIImage(cgImage: cgImage!)

        case 1:
            return UIImage()

        case 2:
            return UIImage()

        case 3:
            return UIImage()

        case 4:
            return UIImage()
        default:
            return UIImage()
        }

    }
}
