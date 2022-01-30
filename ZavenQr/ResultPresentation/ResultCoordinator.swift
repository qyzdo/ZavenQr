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
    private let model: SearchResultEntity

    init(navigationController: UINavigationController, isFromScanner: Bool = false, model: SearchResultEntity) {
        self.navigationController = navigationController
        self.isFromScanner = isFromScanner
        self.model = model
    }

    func start() {
        let viewModel = ResultViewModel(isFromScanner: isFromScanner, model: model)
        let resultViewController = ResultViewController(resultViewModel: viewModel)

        let sheetNavigationController = UINavigationController(rootViewController: resultViewController)

        if let sheet = sheetNavigationController.presentationController as? UISheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium()]
        }

        navigationController.present(sheetNavigationController, animated: true, completion: nil)
    }
}
