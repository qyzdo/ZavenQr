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
import RxCocoa

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

    private let savedListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "folder.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.backgroundColor = (UIColor (white: 0.3, alpha: 1))
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.layer.cornerRadius = 10
        return activityIndicator
    }()

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
        self.navigationController?.isNavigationBarHidden = true
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
        setupSavedListButton()
        setupScanningBox()
        setupDimEffect()
        setupActivityIndicator()
    }

    private func setupPreviewLayer() {
        let layer = scannerViewModel.createPreviewLayer(layerBounds: view.layer.bounds)
        view.layer.addSublayer(layer)
    }

    private func setupSavedListButton() {
        view.addSubview(savedListButton)
        NSLayoutConstraint.activate([
            savedListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            savedListButton.heightAnchor.constraint(equalToConstant: 45),
            savedListButton.widthAnchor.constraint(equalToConstant: 45)
        ])
        view.layoutIfNeeded()
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

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100)
        ])
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

        scannerViewModel.isRefreshing
            .map(!)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicator.rx.isHidden).disposed(by: disposeBag)
    }
}
