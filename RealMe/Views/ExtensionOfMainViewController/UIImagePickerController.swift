//
//  UIImagePickerController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/25.
//

import Foundation
import UIKit
import Photos

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func presentPhotoLibrary() {
        if PhotoAuth() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            AuthSettingOpen(AuthString: "앨범")
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.navigationController?.navigationBar.topItem?.title = ""
            let modiVC = ModifyingViewController()
            modiVC.modifyImage = pickedImage
            self.navigationController?.pushViewController(modiVC, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    func PhotoAuth() -> Bool {
        // 포토 라이브러리 접근 권한
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized:
            print("1")
            return true // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
        case .denied:
            print("2")
            break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
        case .limited:
            print("3")
            break // ?
        case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            print("4")
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    isAuth = true
                }
                
            }
            
            
            print("456")
            return isAuth
        case .restricted:
            print("5")
            break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
        default:
            print("6")
            break
        }
        
        return false;
    }
    func AuthSettingOpen(AuthString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(AuthString) 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?"
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
                print("\(String(describing: UIAlertAction.title)) 클릭")
            }
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            self.present(alert, animated: true, completion: nil)
        }
       
        
        }
}

