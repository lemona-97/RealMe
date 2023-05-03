//
//  ViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/03.
//

import UIKit


extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertController.Style, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: actionTitle, style: .default, handler: .none)
        alert.addAction(actionDone)
        self.present(alert, animated: true, completion: nil)
    }
}
