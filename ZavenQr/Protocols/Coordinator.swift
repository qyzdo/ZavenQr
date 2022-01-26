//
//  Coordinator.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
