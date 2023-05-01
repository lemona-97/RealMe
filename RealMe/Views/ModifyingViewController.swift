//
//  ModifyingViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/01.
//

import UIKit

class ModifyingViewController: UIViewController, ViewControllerProtocol {
    var modifyImage : UIImage?
    let modiImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        setAttribute()
        addView()
        setLayout()
    }
    
    func setAttribute() {
        modiImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        modiImageView.image = modifyImage!
        if let image = modifyImage {
            modiImageView.image = image
        }
    }
    
    func addView() {
        self.view.addSubview(modiImageView)
    }
    
    func setLayout() {
        modiImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            
        }
    }
}
