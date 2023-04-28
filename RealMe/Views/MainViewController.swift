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
class MainViewController: UIViewController, ViewControllerProtocol, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    
    let context = CIContext()
    
    var currentFilter = CIFilter(name: "CISepiaTone")
    var filteredImage =  UIImageView()
    let filterLibraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    
    let photoLibraryButton = UIButton()
    let takePhotoButton = UIButton()
    let changeCameraButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        addTarget()
        addDelegate()
        
        setupDevice()
        setupInputOutput()
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
        self.view.addSubviews([photoLibraryButton, takePhotoButton, filteredImage, changeCameraButton])
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
        filteredImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(takePhotoButton.snp.top).offset(-10)
        }
        filterLibraryCollectionView.snp.makeConstraints {
            $0.leading.equalTo(filteredImage)
            $0.bottom.equalTo(filteredImage)
            $0.height.equalTo(90)
            $0.trailing.equalTo(filteredImage)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                                            { (authorized) in
                DispatchQueue.main.async
                {
                    if authorized
                    {
                        self.setupInputOutput()
                    }
                }
            })
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
    
    func setupInputOutput() {
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
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
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
        
        
        let cgImage = self.context.createCGImage(cameraImage, from: cameraImage.extent)!
        
        if currentCamera?.position == .front {
            print("1")
            DispatchQueue.main.async {
                let filteredImage = UIImage(cgImage: cgImage).withHorizontallyFlippedOrientation()
                self.filteredImage.image = filteredImage
            }
        } else {
            print("2")
            DispatchQueue.main.async {
                let filteredImage = UIImage(cgImage: cgImage)
                self.filteredImage.image = filteredImage
            }
        }
        
    }
    
    @objc func takePhoto() {
        let setting = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: setting, delegate: self)
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
        return devices.filter { $0.position == position }.first
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        self.savePhotoLibrary(image: image)
    }
    func savePhotoLibrary(image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges ({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (success, error) in
                    print("성공, \(success)")
                }
            }
            else {
                print("에러났지롱")
            }
        }
    }
}


