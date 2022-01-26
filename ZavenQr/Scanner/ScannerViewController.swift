//
//  ScannerViewController.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import AVFoundation
import UIKit

final class ScannerViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private let previewLayer: AVCaptureVideoPreviewLayer

    override var prefersStatusBarHidden: Bool {
        return true
    }

    init() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scanningBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupInput()
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
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

    private func setupView() {
        setupPreviewLayer()
        setupScanningBox()
        setupDimEffect()
    }

    private func setupPreviewLayer() {
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    private func setupScanningBox() {
        view.addSubview(scanningBox)
        NSLayoutConstraint.activate([
            scanningBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanningBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanningBox.heightAnchor.constraint(equalToConstant: 200),
            scanningBox.widthAnchor.constraint(equalToConstant: 200)
        ])
        view.layoutIfNeeded()
    }

    private func setupDimEffect() {
        let path = UIBezierPath(rect: view.frame)
        let circlePath = UIBezierPath(rect: scanningBox.frame)
        path.append(circlePath)
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = view.backgroundColor?.cgColor
        fillLayer.opacity = 0.5
        view.layer.addSublayer(fillLayer)
    }
}
