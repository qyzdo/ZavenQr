//
//  ScannerViewModel.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 27/01/2022.
//

import UIKit
import AVFoundation

final class ScannerViewModel {
    private let captureSession = AVCaptureSession()
    private let previewLayer: AVCaptureVideoPreviewLayer

    init() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        setupInput()
    }

    private func setupInput() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            debugPrint("Scanning not supported")
            return
        }
    }

    func createPreviewLayer(layerBounds: CGRect) -> AVCaptureVideoPreviewLayer{
        previewLayer.frame = layerBounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }

    func stopCaptureSessionIfNeeded() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    func startCaptureSessionIfNeeded() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
}
