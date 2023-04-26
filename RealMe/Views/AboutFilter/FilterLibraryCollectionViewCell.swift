//
//  filterLibraryCollectionViewCell.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/24.
//

import UIKit

final class FilterLibraryCollectionViewCell: UICollectionViewCell, ViewControllerProtocol {
    
    var sampleImageView = UIImageView()
    var sampleImageName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttribute()
        addView()
        setLayout()
    }
    
    func setAttribute() {

        contentView.backgroundColor = .white
        
        sampleImageName.do {
            $0.text = "필터명"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title3), size: CGFloat(11.0))
        }
    }
    func addView() {
        contentView.addSubview(sampleImageView)
        contentView.addSubview(sampleImageName)
    }
    func setLayout() {
        sampleImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        sampleImageName.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(10)
            $0.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
