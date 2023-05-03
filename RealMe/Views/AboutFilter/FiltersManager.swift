//
//  filters.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import UIKit
import CoreImage

private let filters : [String] = ["CISepiaTone", "CIMaskToAlpha", "CIXRay", "CIVignette"]

struct FilteredInfoWithKoreanWithCIFilter {
    let resultFilterInfo : String
    let resultFilterKoreanName : String
    let resultCIFilteredCIImage : CIImage?
    init(resultFilterInfo: String, resultFilterKoreanName: String, resultCIFilteredCIImage: CIImage?) {
        self.resultFilterInfo = resultFilterInfo
        self.resultFilterKoreanName = resultFilterKoreanName
        self.resultCIFilteredCIImage = resultCIFilteredCIImage
    }
}

let filterCount = 6

class FilterManager {
    static func returnAboutFilter(_ image : CIImage, _ filterName: Int) -> FilteredInfoWithKoreanWithCIFilter {
        switch filterName {
        case 0:
            let filterInfo = ""
            let filterKorean = "기본"
            let filteredCIImage = image
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)

        case 1:
            let filterInfo = "CIMaskToAlpha"
            let filterKorean = "다날려"
            let filter = CIFilter(name: filterInfo)
            filter?.setValue(image, forKey: kCIInputImageKey)
            
            let filteredCIImage = filter?.outputImage
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)

        case 2:
            let filterInfo = "CIXRay"
            let filterKorean = "엑스레이"
            let filter = CIFilter(name: filterInfo)
            filter?.setValue(image, forKey: kCIInputImageKey)
            let filteredCIImage = filter?.outputImage
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)

        case 3:
            let filterInfo = "CIColorMonochrome"
            let filterKorean = "심령사진"
            let filter = CIFilter(name: filterInfo)
            filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            filter?.setValue(image, forKey: kCIInputImageKey)
            filter?.setValue(CIColor(color: .blue), forKey: kCIInputColorKey)
            
            let filteredCIImage = filter?.outputImage
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)
        case 4:
            let filterInfo = "CISepiaTone"
            let filterKorean = "노을"
            let filter = CIFilter(name: filterInfo)
            filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            filter?.setValue(image, forKey: kCIInputImageKey)
            let filteredCIImage = filter?.outputImage
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)
        case 5:
            let filterInfo = "CIFalseColor"
            let filterKorean = "색반전"
            let filter = CIFilter(name: filterInfo)
            filter?.setValue(image, forKey: kCIInputImageKey)
            let filteredCIImage = filter?.outputImage
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean, resultCIFilteredCIImage: filteredCIImage)

        default:
            return FilteredInfoWithKoreanWithCIFilter(resultFilterInfo: "CISepiaTone", resultFilterKoreanName: "노을",resultCIFilteredCIImage: CIImage(image: UIImage(named: "샘플이미지")!))
        }

    }
}
