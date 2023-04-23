//
//  filters.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import Foundation
import UIKit
import CoreImage

struct FilteredImageWithName {
    let resultFilterdUIImage : UIImage
    let resultFilterName : String
    init(resultFilterdUIImage: UIImage, resultFilterName: String) {
        self.resultFilterdUIImage = resultFilterdUIImage
        self.resultFilterName = resultFilterName
    }
}
class FilterManager {
    static func returnFilteredUIImage(_ beforeImage: UIImage, _ filterName: Int) -> FilteredImageWithName {
        let context = CIContext()
        switch filterName {
        case 0:
            let filterName = "CISepiaTone"
            let filterKorean = "분위기"
            let filter = CIFilter(name: filterName)!
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            let image = CIImage(image: beforeImage)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return FilteredImageWithName(resultFilterdUIImage: UIImage(cgImage: cgImage!), resultFilterName: filterKorean)

        case 1:
            let filterName = "CIMaskToAlpha"
            let filterKorean = "다날려"
            let filter = CIFilter(name: filterName)!
            let image = CIImage(image: beforeImage)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return FilteredImageWithName(resultFilterdUIImage: UIImage(cgImage: cgImage!), resultFilterName: filterKorean)

        case 2:
            let filterName = "CIXRay"
            let filterKorean = "엑스레이"
            let filter = CIFilter(name: filterName)!
            let image = CIImage(image: beforeImage)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return FilteredImageWithName(resultFilterdUIImage: UIImage(cgImage: cgImage!), resultFilterName: filterKorean)

        case 3:
            let filterName = "CIVignette"
            let filterKorean = "선명함"
            let filter = CIFilter(name: filterName)!
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            filter.setValue(3.0, forKey: kCIInputRadiusKey)
            let image = CIImage(image: beforeImage)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return FilteredImageWithName(resultFilterdUIImage: UIImage(cgImage: cgImage!), resultFilterName: filterKorean)

        default:
            
            return FilteredImageWithName(resultFilterdUIImage: UIImage(named: "1")!, resultFilterName: "기본")
        }

    }
}
