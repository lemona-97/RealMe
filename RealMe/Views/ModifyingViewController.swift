//
//  ModifyingViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/01.
//

import UIKit
import SnapKit
import Then
import Photos

final class ModifyingViewController: UIViewController, ViewControllerProtocol {
    
    var modifyImage : UIImage?
    let modiImageView = UIImageView()
    let savePhotoButton = UIButton()
    
    let filterLibraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    override func viewDidLoad() {
        super.viewDidLoad()

        setAttribute()
        addView()
        setLayout()
        addDelegate()
        addTarget()
    }
    
    func setAttribute() {
        modiImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .black
            $0.image = modifyImage!
        }
        filterLibraryCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = true
            $0.showsVerticalScrollIndicator = false
            $0.collectionViewLayout = layout
            $0.register(FilterLibraryCollectionViewCell.self, forCellWithReuseIdentifier: "FilterLibraryCollectionViewCell")
        }
        let imageConfig50 = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        
        savePhotoButton.do {
            $0.setImage(UIImage(systemName: "arrow.down.circle", withConfiguration: imageConfig50), for: .normal)
            $0.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig50), for: .highlighted)
            $0.tintColor = .white
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 35
            
        }
    }
    func addView() {
        self.view.addSubviews([modiImageView, savePhotoButton])
        self.view.addSubview(filterLibraryCollectionView)
    }
    func setLayout() {
        self.view.backgroundColor = .white
        modiImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        savePhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(70)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        filterLibraryCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(savePhotoButton.snp.top)
            $0.height.equalTo(90)
            $0.leading.trailing.equalToSuperview()
        }
    }
    func addDelegate() {
        filterLibraryCollectionView.delegate = self
        filterLibraryCollectionView.dataSource = self
    }
    func addTarget() {
        savePhotoButton.addTarget(self, action: #selector(savePhotoLibrary), for: .touchUpInside)
    }
    
    @objc func savePhotoLibrary(){
        let photoData = self.modiImageView.image!.jpegData(compressionQuality: 1.0)
        PHPhotoLibrary.shared().performChanges({
                    // 앨범에 이미지 저장
                    let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: photoData!, options: nil)
                }, completionHandler: { success, error in
                    if success {
                        print("이미지 저장 완료.")
                    } else {
                        print("이미지 저장 실패.")
                    }
        })
        showAlert(title: "앨범에 사진 저장", message: "성공!", style: .alert, actionTitle: "확인")
    }
}

extension ModifyingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterLibraryCollectionViewCell", for: indexPath) as? FilterLibraryCollectionViewCell else { return UICollectionViewCell() }

        if FilterManager.returnAboutFilter(CIImage(), indexPath.row).resultFilterInfo == "" {
            cell.sampleImageName.text = FilterManager.returnAboutFilter(CIImage(), 0).resultFilterKoreanName
        } else {
            let result = FilterManager.returnAboutFilter(CIImage(image: cell.sampleImageView.image!)!, indexPath.row).resultCIFilteredCIImage!
            let cgImage = CIContext().createCGImage(result, from: result.extent)!
            cell.sampleImageView.image = UIImage(cgImage: cgImage)
            cell.sampleImageName.text = FilterManager.returnAboutFilter(CIImage(), indexPath.row).resultFilterKoreanName
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)번째 필터 적용 준비.")

        let ciImage = CIImage(image: self.modifyImage!)!

        let filteredImage = FilterManager.returnAboutFilter(ciImage, indexPath.row).resultCIFilteredCIImage!
        let cgImage = CIContext().createCGImage(filteredImage, from: filteredImage.extent)!

        self.modiImageView.image = UIImage(cgImage: cgImage, scale: self.modifyImage!.scale, orientation: self.modifyImage!.imageOrientation)
    }
    
}
