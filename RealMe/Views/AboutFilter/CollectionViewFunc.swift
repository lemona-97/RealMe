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
        filterCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterLibraryCollectionViewCell", for: indexPath) as? FilterLibraryCollectionViewCell else { return UICollectionViewCell() }
        
        if FilterManager.returnAboutFilter(CIImage(), indexPath.row).resultFilterInfo == "" {
            cell.sampleImageName.text = FilterManager.returnAboutFilter(CIImage(), 0).resultFilterKoreanName
        } else {
            let result = FilterManager.returnAboutFilter(CIImage(image: cell.sampleImageView.image!)!, indexPath.row).resultCIFilteredCIImage!
            let cgImage = context.createCGImage(result, from: result.extent)
            cell.sampleImageView.image = UIImage(cgImage: cgImage!)
            cell.sampleImageName.text = FilterManager.returnAboutFilter(CIImage(), indexPath.row).resultFilterKoreanName
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(indexPath.row)번째 필터 적용 준비.")
        print(FilterManager.returnAboutFilter(CIImage(), indexPath.row).resultFilterKoreanName)
        self.currentFilterNum = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 70)
    }
}
