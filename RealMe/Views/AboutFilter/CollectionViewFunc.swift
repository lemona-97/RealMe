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
        let filter = CIFilter(name: FilterManager.returnFilterName(indexPath.row).resultFilterInfo)!
        let image = CIImage(image: cell.sampleImageView.image!)
        filter.setValue(image, forKey: kCIInputImageKey)
        let result = filter.outputImage!
        let cgImage = context.createCGImage(result, from: result.extent)
        cell.sampleImageView.image = UIImage(cgImage: cgImage!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(FilterManager.returnFilterName(indexPath.row), "필터 적용준비")
        self.currentFilter = CIFilter(name: FilterManager.returnFilterName(indexPath.row).resultFilterInfo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 70)
    }
}
