//
//  SceneDelegate.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 26/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
               let vc = ViewController()

               let window = UIWindow(windowScene: windowScene)
               window.rootViewController = vc
               self.window = window

               window.makeKeyAndVisible()
    }
}
