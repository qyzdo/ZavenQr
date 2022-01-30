//
//  ResultCoordinator.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit

final class ResultCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let isFromScanner: Bool

    init(navigationController: UINavigationController, isFromScanner: Bool = false) {
        self.navigationController = navigationController
        self.isFromScanner = isFromScanner
    }

    func start() {
        let resultViewController = ResultViewController(resultViewModel: ResultViewModel(isFromSearch: isFromScanner))

        let sheetNavigationController = UINavigationController(rootViewController: resultViewController)

        if let sheet = sheetNavigationController.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium()]
        }

        navigationController.present(sheetNavigationController, animated: true, completion: nil)
    }
}
