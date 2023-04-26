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
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterLibraryCollectionViewCell", for: indexPath) as? FilterLibraryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.sampleImageView.image = FilterManager.returnFilteredUIImage(UIImage(named: "1")!, indexPath.row).resultFilterdUIImage
        cell.sampleImageName.text =  FilterManager.returnFilteredUIImage(UIImage(named: "1")!, indexPath.row).resultFilterName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(FilterManager.returnFilteredUIImage(UIImage(named: "1")!, indexPath.row).resultFilterName, "필터 적용준비")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 70)
    }
}
