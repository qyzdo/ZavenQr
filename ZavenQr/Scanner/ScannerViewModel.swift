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
    private let apiClient = APIClient()
    private let qrCodeSubject = PublishSubject<String>()

    let isRefreshing = BehaviorRelay<Bool>(value: false)
    let errorSubject = PublishSubject<String>()
    let resultModelSubject = PublishSubject<SearchResultEntity>()

    override init() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init()
    }

    func setupInputAndOutPut() {
        subscribeForResult()
        setupInput()
        setupOutPut()
    }

    private func subscribeForResult() {
        qrCodeSubject.asObservable()
            .map { ($0 ).lowercased() }
            .map { (FindImageRequest(name: $0), $0)}
            .map { request, qrCodePhrase -> (Observable<UnsplashModel>, String) in
                return (self.apiClient.send(apiRequest: request), qrCodePhrase)
            }.subscribe { [weak self] observableResult, qrCodePhrase in
                observableResult.subscribe { [weak self] model in
                    guard let firstResult = model.results.first,let url = URL(string: firstResult.urls.regular) else {
                        self?.startCaptureSessionIfNeeded()
                        return
                    }

                    DispatchQueue.main.async {
                        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            let model = CoreDataHelper.shared.createModel(searchedPhrase: qrCodePhrase, photoUrl: model.results.first!.urls.regular, image: image)
                            self?.resultModelSubject.onNext(model)
                        } else {
                            self?.startCaptureSessionIfNeeded()
                        }
                        self?.isRefreshing.accept(false)
                    }
                } onError: { error in
                    self?.isRefreshing.accept(false)
                    self?.errorSubject.onNext(error.localizedDescription)
                }.disposed(by: self!.disposeBag)

            }.disposed(by: disposeBag)
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
        stopCaptureSessionIfNeeded()
        isRefreshing.accept(true)
        qrCodeSubject.onNext(qrCodeString)
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
