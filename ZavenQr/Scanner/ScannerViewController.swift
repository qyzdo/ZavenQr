//
//  ScannerViewController.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import AVFoundation
import UIKit
import RxSwift
import SwiftMessages

final class ScannerViewController: UIViewController {
    private let scannerViewModel: ScannerViewModel
    private let disposeBag = DisposeBag()

    weak var coordinator: ScannerCoordinator?

    override var prefersStatusBarHidden: Bool {
        return true
    }

    init(scannerViewModel: ScannerViewModel) {
        self.scannerViewModel = scannerViewModel
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
        scannerViewModel.startCaptureSessionIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        bindViewModel()

        scannerViewModel.setupInputAndOutPut()
        scannerViewModel.setupScanningArea(scanningBox.frame)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scannerViewModel.stopCaptureSessionIfNeeded()
    }

    private func setupView() {
        setupPreviewLayer()
        setupScanningBox()
        setupDimEffect()
    }

    private func setupPreviewLayer() {
        let layer = scannerViewModel.createPreviewLayer(layerBounds: view.layer.bounds)
        view.layer.addSublayer(layer)
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

    private func bindViewModel() {
        scannerViewModel.errorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{
            let messageView = MessageView.viewFromNib(layout: .cardView)
            messageView.button?.isHidden = true
            messageView.configureTheme(.error)
            messageView.configureDropShadow()
            messageView.configureContent(title: "Error", body: $0, iconText: "❌")
            (messageView.backgroundView as? CornerRoundingView)?.cornerRadius = 10

            SwiftMessages.show(view: messageView)
        }).disposed(by: disposeBag)
    }
}
