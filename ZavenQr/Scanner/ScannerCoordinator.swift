//
//  ScannerCoordinator.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import Foundation
import UIKit

final class ScannerCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let scannerViewController = ScannerViewController(scannerViewModel: ScannerViewModel())
        scannerViewController.coordinator = self
        navigationController.setViewControllers([scannerViewController], animated: true)
    }

    func showResultView(model: SearchResultEntity) {
        let resultCoordinator = ResultCoordinator(navigationController: navigationController, isFromScanner: true, model: model)
        resultCoordinator.start()
    }
}
