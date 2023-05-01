//
//  collectionViewFunc.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import UIKit
import AVFoundation

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterLibraryCollectionViewCell", for: indexPath) as? FilterLibraryCollectionViewCell else { return UICollectionViewCell() }
        if FilterManager.returnFilterName(indexPath.row).resultFilterInfo == "" {
            cell.sampleImageName.text = FilterManager.returnFilterName(indexPath.row).resultFilterKoreanName
        } else {
            let filter = CIFilter(name: FilterManager.returnFilterName(indexPath.row).resultFilterInfo)!
            let image = CIImage(image: cell.sampleImageView.image!)
            filter.setValue(image, forKey: kCIInputImageKey)
            let result = filter.outputImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            cell.sampleImageView.image = UIImage(cgImage: cgImage!)
            cell.sampleImageName.text = FilterManager.returnFilterName(indexPath.row).resultFilterKoreanName
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("필터 적용 준비.")
        if FilterManager.returnFilterName(indexPath.row).resultFilterInfo == "" {
            self.currentFilter = nil
            print("기본 필터 적용")
        } else {
            self.currentFilter = CIFilter(name: FilterManager.returnFilterName(indexPath.row).resultFilterInfo)
            print("\(FilterManager.returnFilterName(indexPath.row).resultFilterInfo) 필터 적용 완료.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 70)
    }
}
