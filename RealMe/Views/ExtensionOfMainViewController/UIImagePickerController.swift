//
//  UIImagePickerController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/25.
//

import Foundation
import UIKit

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func presentPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self //3
        self.present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 아직 미구현 사진 집기 -> stop running -> view 띄우고 사진 넣기 + 필터 가져오기
            self.captureSession.stopRunning()
            
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        dismiss(animated: true, completion: nil)
        
    }
}

