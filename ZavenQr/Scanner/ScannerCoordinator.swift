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
        let scannerViewController = ScannerViewController()
        scannerViewController.coordinator = self
        navigationController.setViewControllers([scannerViewController], animated: true)
    }

    func test() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController.pushViewController(vc, animated: true)
    }
}
