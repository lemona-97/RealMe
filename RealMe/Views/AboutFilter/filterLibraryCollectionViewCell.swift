//
//  filterLibraryCollectionViewCell.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import UIKit

final class filterLibraryCollectionViewCell: UICollectionViewCell, ViewControllerProtocol {
    
    
    var sample = UIImageView()
    var sampleImage = CIImage(image: UIImage(systemName: "circle")!)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        addView()
        setLayout()
    }
    
    func setAttribute() {

        contentView.backgroundColor = .white
        
        sample.do {
            $0.image = FilterManager.returnCIFilter(UIImage(named: "1")!, 0)
        }
    }
    func addView() {
        contentView.addSubview(sample)
    }
    func setLayout() {
        sample.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
