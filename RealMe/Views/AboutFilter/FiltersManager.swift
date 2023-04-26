//
//  filters.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import Foundation
import UIKit
import CoreImage

struct FilteredInfoWithKorean {
    let resultFilterInfo : String
    let resultFilterKoreanName : String
    init(resultFilterInfo: String, resultFilterKoreanName: String) {
        self.resultFilterInfo = resultFilterInfo
        self.resultFilterKoreanName = resultFilterKoreanName
    }
}
class FilterManager {
    static func returnFilterName(_ filterName: Int) -> FilteredInfoWithKorean {
        switch filterName {
        case 0:
            let filterInfo = "CISepiaTone"
            let filterKorean = "노을"
            return FilteredInfoWithKorean(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean)

        case 1:
            let filterInfo = "CIMaskToAlpha"
            let filterKorean = "다날려"
            return FilteredInfoWithKorean(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean)

        case 2:
            let filterInfo = "CIXRay"
            let filterKorean = "엑스레이"
            return FilteredInfoWithKorean(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean)

        case 3:
            let filterInfo = "CIVignette"
            let filterKorean = "선명함"
            return FilteredInfoWithKorean(resultFilterInfo: filterInfo, resultFilterKoreanName: filterKorean)

        default:
            return FilteredInfoWithKorean(resultFilterInfo: "CISepiaTone", resultFilterKoreanName: "노을")
        }

    }
}
