//
//  ResultViewController.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit
import RxSwift

final class ResultViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let resultViewModel: ResultViewModel

    init(resultViewModel: ResultViewModel) {
        self.resultViewModel = resultViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()

    private let mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray4
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }

    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        setupCancelButtonView()
        setupMainLabelView()
        setupSecondLabel()
        setupImageView()
        setupMainButtonView()

        if resultViewModel.isFromScanner {
            mainLabel.font = UIFont.systemFont(ofSize: 25)
            secondLabel.font = UIFont.systemFont(ofSize: 15)
        } else {
            mainLabel.font = UIFont.systemFont(ofSize: 20)
            secondLabel.font = UIFont.systemFont(ofSize: 10)
        }
    }

    private func setupCancelButtonView() {
        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: 35),
            cancelButton.widthAnchor.constraint(equalToConstant: 35),
        ])
    }

    private func setupMainLabelView() {
        view.addSubview(mainLabel)

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(lessThanOrEqualTo: cancelButton.leadingAnchor, constant: -10),
        ])
    }

    private func setupSecondLabel() {
        view.addSubview(secondLabel)

        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            secondLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            secondLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }

    private func setupImageView() {
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(greaterThanOrEqualTo: secondLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 230),
            imageView.widthAnchor.constraint(equalToConstant: 230),
        ])
    }

    private func setupMainButtonView() {
        view.addSubview(mainButton)

        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func bindViewModel() {
        mainLabel.text = resultViewModel.getMainLabelText()
        secondLabel.text = resultViewModel.getSecondLabelText()
        mainButton.setTitle(resultViewModel.getButtonTitleText(), for: .normal)
        imageView.image = resultViewModel.getImage()

        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        mainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.resultViewModel.isFromScanner {
                    self.resultViewModel.saveModel()
                    self.dismiss(animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
