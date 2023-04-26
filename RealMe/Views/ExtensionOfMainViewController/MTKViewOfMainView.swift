//
//  MTKViewOfMainView.swift
//  RealMe
//
//  Created by 임우섭 on 2023/04/23.
//

import UIKit
import AVFoundation
//
//extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer), let _ = CMSampleBufferGetFormatDescription(sampleBuffer) else {return}
//
//            let comicEffect = CIFilter(name: "CIComicEffect")
//            let cameraImage = CIImage(cvImageBuffer: videoPixelBuffer)
//
//            comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
//
//            let cgImage = self.context.createCGImage(comicEffect!.outputImage!, from: cameraImage.extent)!
//
//            DispatchQueue.main.async {
//                let filteredImage = UIImage(cgImage: cgImage)
//                self.capturedImageView.image = filteredImage
//            }
//        }
//
//}
