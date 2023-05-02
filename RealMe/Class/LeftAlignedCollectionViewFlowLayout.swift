//
//  LeftAlignedCollectionViewFlowLayout.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import Foundation
import UIKit

//UICollectionViewCell 최대한 왼쪽정렬 시켜주는 flowlayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 15
        self.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
