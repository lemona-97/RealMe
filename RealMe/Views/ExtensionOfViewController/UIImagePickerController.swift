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
            self.captureSession.stopRunning()
            self.capturedImageView.image = pickedImage
            captureSession?.commitConfiguration()
        }
        DispatchQueue.global().async {
            self.captureSession.startRunning()
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

