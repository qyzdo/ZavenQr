//
//  ResultViewController.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit

final class ResultViewController: UIViewController {
    private let resultViewModel: ResultViewModel

    init(resultViewModel: ResultViewModel) {
        self.resultViewModel = resultViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .red
    }
}
