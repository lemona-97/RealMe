//
//  MainViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/03/23.
//

import UIKit
import AVFoundation
import SnapKit

import Then
import Photos
import RxSwift
import RxGesture

final class MainViewController: UIViewController, ViewControllerProtocol, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    let context = CIContext()
    var currentCGImage : CGImage?
    
    var photoData : Data?
    var currentFilterNum = 0
    var filteredImageView =  UIImageView()
    let filterLibraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    
    let photoLibraryButton = UIButton()
    let takePhotoButton = UIButton()
    let changeCameraButton = UIButton()
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        addTarget()
        addDelegate()
        
        
        setupDevice()
        setupInputOutput()
        requestAuth()
        autoFocus()
    }
    func setAttribute() {
        let imageConfig30 = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let imageConfig70 = UIImage.SymbolConfiguration(pointSize: 70, weight: .light)
        
        
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
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = true
            $0.showsVerticalScrollIndicator = false
            $0.collectionViewLayout = layout
            $0.register(FilterLibraryCollectionViewCell.self, forCellWithReuseIdentifier: "FilterLibraryCollectionViewCell")
        }
    }
    func addView() {
        self.view.addSubviews([photoLibraryButton, takePhotoButton, filteredImageView, changeCameraButton])
        self.view.addSubview(filterLibraryCollectionView)
    }
    func setLayout() {
        takePhotoButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
        filteredImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-10)
        }
        filterLibraryCollectionView.snp.makeConstraints {
            $0.leading.equalTo(filteredImageView)
            $0.bottom.equalTo(filteredImageView)
            $0.height.equalTo(75)
            $0.trailing.equalTo(filteredImageView)
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
    override func viewDidLayoutSubviews() {
        orientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
    }
    func autoFocus() {
        print("auto focusing set.")
        self.filteredImageView.rx.tapGesture()
            .asDriver()
            .drive(onNext: { [weak self] (gesture) in
                print("?")
                self?.tapFocus(gesture)
            }).disposed(by: bag)
        

    }
    private func tapFocus(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            let thisFocusPoint = sender.location(in: filteredImageView)
            focusAnimationAt(thisFocusPoint)

            let focus_x = thisFocusPoint.x / filteredImageView.frame.size.width
            let focus_y = thisFocusPoint.y / filteredImageView.frame.size.height
            
            if (currentCamera!.isFocusModeSupported(.autoFocus) && currentCamera!.isFocusPointOfInterestSupported) {
                do {
                    try currentCamera?.lockForConfiguration()
                    currentCamera?.focusMode = .autoFocus
                    currentCamera?.focusPointOfInterest = CGPoint(x: focus_x, y: focus_y)

                    if (currentCamera!.isExposureModeSupported(.autoExpose) && currentCamera!.isExposurePointOfInterestSupported) {
                        currentCamera?.exposureMode = .autoExpose;
                        currentCamera?.exposurePointOfInterest = CGPoint(x: focus_x, y: focus_y);
                     }

                    currentCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: UIImage(named: "aim"))
        focusView.center = point
        filteredImageView.addSubview(focusView)

        focusView.transform = CGAffineTransform(scaleX: 2, y: 2)

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 1, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
        
    }
    
    public func setupInputOutput() {
        do {
            setupCorrectFramerate(currentCamera: currentCamera!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        } catch {
            print(error)
        }
    }
    
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            let ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
            let frameRates = ranges[0]
            
            do {
                //set to 240fps - available types are: 30, 60, 120 and 240 and custom
                // lower framerates cause major stuttering
                if frameRates.maxFrameRate == 240 {
                    try currentCamera.lockForConfiguration()
                    currentCamera.activeFormat = vFormat as AVCaptureDevice.Format
                    //for custom framerate set min max activeVideoFrameDuration to whatever you like, e.g. 1 and 180
                    currentCamera.activeVideoMinFrameDuration = frameRates.minFrameDuration
                    currentCamera.activeVideoMaxFrameDuration = frameRates.maxFrameDuration
                }
            }
            catch {
                print("Could not set active format")
                print(error)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        
        if currentFilterNum == 0 {
            if currentCamera?.position == .front {
                currentCGImage =  context.createCGImage(cameraImage, from: cameraImage.extent)
                
                DispatchQueue.main.async {
                    self.filteredImageView.image = UIImage(cgImage: self.currentCGImage!).withHorizontallyFlippedOrientation()
                }
            } else {
                DispatchQueue.main.async {
                    self.filteredImageView.image = UIImage(ciImage: cameraImage)
                }
            }
            
        } else {
            let result = FilterManager.returnAboutFilter(cameraImage, currentFilterNum).resultCIFilteredCIImage!
            currentCGImage = context.createCGImage(result, from: result.extent)!
            
            if currentCamera?.position == .front {
                let filteredImage = UIImage(cgImage: self.currentCGImage!).withHorizontallyFlippedOrientation()
                DispatchQueue.main.async {
                    self.filteredImageView.image = filteredImage
                }
            } else {
                let filteredImage = UIImage(cgImage: self.currentCGImage!)
                DispatchQueue.main.async {
                    self.filteredImageView.image = filteredImage
                }
            }
        }
        
        
    }
    
    @objc func takePhoto() {
        savePhotoLibrary(image: filteredImageView.image!)
    }
    @objc func switchCamera() {
        captureSession.beginConfiguration()
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        captureSession.removeInput(currentInput!)
        
        let newCameraDevice = currentInput?.device.position == .back ? camera(with: .front) : camera(with: .back)
        currentCamera = newCameraDevice!
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession.addInput(newVideoInput!)
        captureSession.commitConfiguration()
    }
    private func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        print("카메라 전/후면 전환")
        return devices.filter { $0.position == position }.first
    }
    
    func savePhotoLibrary(image: UIImage) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        let photoData = image.jpegData(compressionQuality: 1.0)
        PHPhotoLibrary.shared().performChanges({
                    // 앨범에 이미지 저장
                    let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: photoData!, options: nil)
                }, completionHandler: { success, error in
                    if success {
                        print("이미지 저장 완료.")
                        DispatchQueue.main.async {
                            self.showAlert(title: "앨범에 사진 저장", message: "성공", style: .alert, actionTitle: "확인")
                        }
                        
                    } else {
                        print("이미지 저장 실패.")
                    }
        })
        
    }
    func requestAuth() {
        PHPhotoLibrary.requestAuthorization { state in
            if state == .authorized {
                PHPhotoLibrary.authorizationStatus(for: .readWrite)
            }
        }
    }
}


