//
//  ScannerViewModel.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 27/01/2022.
//

import UIKit
import AVFoundation
import RxSwift
import RxRelay

final class ScannerViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    private let captureSession = AVCaptureSession()
    private let previewLayer: AVCaptureVideoPreviewLayer
    private let metadataOutput = AVCaptureMetadataOutput()
    private let disposeBag = DisposeBag()
    
    let isRefreshing = BehaviorRelay<Bool>(value: false)
    let errorSubject = PublishSubject<String>()

    override init() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init()
    }

    func setupInputAndOutPut() {
        setupInput()
        setupOutPut()
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
            errorSubject.onNext("Scanning not supported")
            return
        }
    }

    private func setupOutPut() {
        guard captureSession.canAddOutput(metadataOutput) else {
            errorSubject.onNext("Scanning not supported")
            return
        }
        
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
    }

    func startCaptureSessionIfNeeded() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    func stopCaptureSessionIfNeeded() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let qrCodeString = readableObject.stringValue else { return }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        // TODO: Should start searching for image with qrCodeString name
        stopCaptureSessionIfNeeded()
    }

    func createPreviewLayer(layerBounds: CGRect) -> AVCaptureVideoPreviewLayer{
        previewLayer.frame = layerBounds
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }

    func setupScanningArea(_ scanningArea: CGRect) {
        let scanningAreaRect = previewLayer.metadataOutputRectConverted(fromLayerRect: scanningArea)
        metadataOutput.rectOfInterest = scanningAreaRect
    }
}
