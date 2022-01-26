//
//  AppCoordinator.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Possible to change initial ViewController here
        openScanner()
    }

    private func openScanner() {
        let viewController = ScannerViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}
