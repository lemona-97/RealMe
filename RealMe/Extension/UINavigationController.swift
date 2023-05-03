//
//  UINavigationController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/03.
//

import UIKit

extension UINavigationController {
    open override func viewDidDisappear(_ animated: Bool) {
        self.navigationBar.backgroundColor = .clear
    }
}
