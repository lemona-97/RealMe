//
//  MainViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/23.
//

import UIKit
import AVFoundation
import Then
import SnapKit


final class MainViewController: UIViewController, ViewControllerProtocol, AVCapturePhotoCaptureDelegate {
    
    let preView = UIView()
    let takePhotoButton = UIButton()
    let capturedImageView = UIImageView()
    let changeCameraButton = UIButton()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAttribute()
        addView()
        setLayout()
        addTarget()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        //NOTE: If you plan to upload your photo to Parse, you will likely need to change your preset to
        //AVCaptureSession.Preset.High or AVCaptureSession.Preset.medium to keep the size under the 10mb Parse max.
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
//        guard let frontCamera = AVCaptureDevice.default(for: .video)
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        preView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.preView.bounds
            }
        }
        
    }
    func setAttribute() {
        preView.do {
            $0.backgroundColor = .white
        }
        let imageConfig70 = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        let imageConfig30 = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        takePhotoButton.do {
            $0.setImage(UIImage(systemName: "button.programmable", withConfiguration: imageConfig70), for: .normal)
            $0.tintColor = .white
        }
        changeCameraButton.do {
            $0.setImage(UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: imageConfig30), for: .normal)
            $0.tintColor = .white
        }
    }
    
    func addView() {
        self.view.addSubviews([preView,takePhotoButton,capturedImageView,changeCameraButton])
    }
    
    func setLayout() {
        takePhotoButton.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
        preView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-30)
        }
        changeCameraButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalTo(takePhotoButton)
            $0.width.height.equalTo(70)
        }
    }
    func addTarget() {
        takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        changeCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
    }
    
    @objc func takePhoto() {
        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: setting, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        capturedImageView.image = image
    }
    @objc private func switchCamera() {
        captureSession?.beginConfiguration()
        let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
        captureSession?.removeInput(currentInput!)

        let newCameraDevice = currentInput?.device.position == .back ? camera(with: .front) : camera(with: .back)
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession?.addInput(newVideoInput!)
        captureSession?.commitConfiguration()
    }
    private func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        return devices.filter { $0.position == position }.first
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}
