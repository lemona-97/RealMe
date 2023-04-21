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
    let capturedImageView = UIImageView()
    let photoLibraryButton = UIButton()
    let takePhotoButton = UIButton()
    let changeCameraButton = UIButton()
    
    let filterLibraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        
        addTarget()
        addDelegate()
        captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .medium
        captureSession.sessionPreset = .medium
        //NOTE: If you plan to upload your photo to Parse, you will likely need to change your preset to
        //AVCaptureSession.Preset.High or AVCaptureSession.Preset.medium to keep the size under the 10mb Parse max.
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
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
        let imageConfig30 = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let imageConfig70 = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        
        preView.do {
            $0.backgroundColor = .white
        }
        photoLibraryButton.do {
            $0.setImage(UIImage(systemName: "photo",withConfiguration: imageConfig30), for: .normal)
            $0.tintColor = .white
        }
        takePhotoButton.do {
            $0.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: imageConfig70), for: .normal)
            $0.tintColor = .white
        }
        changeCameraButton.do {
            $0.setImage(UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: imageConfig30), for: .normal)
            $0.tintColor = .white
        }
        filterLibraryCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            $0.backgroundColor = .red
            $0.showsHorizontalScrollIndicator = true
            $0.showsVerticalScrollIndicator = false
            $0.collectionViewLayout = layout
            $0.register(filterLibraryCollectionViewCell.self, forCellWithReuseIdentifier: "filterLibraryCollectionViewCell")
        }
    }
    
    func addView() {
        self.view.addSubviews([preView, photoLibraryButton, takePhotoButton, capturedImageView, changeCameraButton])
        self.view.addSubview(filterLibraryCollectionView)
    }
    
    func setLayout() {
        takePhotoButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        preView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-30)
        }
        photoLibraryButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(45)
            $0.centerY.equalTo(takePhotoButton)
            $0.leading.equalToSuperview().offset(30)
        }
        
        changeCameraButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalTo(takePhotoButton)
            $0.width.height.equalTo(70)
        }
        filterLibraryCollectionView.snp.makeConstraints {
            $0.leading.equalTo(preView).offset(15)
            $0.bottom.equalTo(preView).offset(-10)
            $0.height.equalTo(70)
            $0.trailing.equalTo(preView).offset(-15)
        }
    }
    func addDelegate() {
        filterLibraryCollectionView.delegate = self
        filterLibraryCollectionView.dataSource = self
    }
    func addTarget() {
        photoLibraryButton.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
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
//        let devices2 = AVCaptureDevice.devices
        return devices.filter { $0.position == position }.first
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}


