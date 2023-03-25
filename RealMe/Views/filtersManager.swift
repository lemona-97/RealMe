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
    static func returnCIFilter(_ filterName: Int) -> CIFilter {
        switch filterName {
        case 0:
            let context = CIContext()
            let filter = CIFilter(name: "abcd")!
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            let image = CIImage(image: UIImage(systemName: "circle")!)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            return CIFilter()

        case 1:
            return CIFilter()

        case 2:
            return CIFilter()

        case 3:
            return CIFilter()

        case 4:
            return CIFilter()
        default:
            return CIFilter()
        }

    }
}
