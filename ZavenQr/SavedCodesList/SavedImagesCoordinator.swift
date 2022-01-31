//
//  SavedImagesCoordinator.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit

final class SavedImagesCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let savedImagesList = SavedCodesTableViewController(savedImagesViewModel: SavedImagesViewModel())
        savedImagesList.coordinator = self
        navigationController.pushViewController(savedImagesList, animated: true)
    }

    func showResultView(mode: SearchResultEntity) {
        let coordinator = ResultCoordinator(navigationController: navigationController, model: mode)
        coordinator.start()
    }
}
