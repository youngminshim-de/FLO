//
//  SceneDelegate.swift
//  FLO
//
//  Created by 심영민 on 6/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                let window = UIWindow(windowScene: windowScene)
                let viewController = BrowserViewController()
                viewController.view.backgroundColor = .white
                viewController.reactor = BrowserReactor()
                window.rootViewController = viewController
                self.window = window
                window.makeKeyAndVisible()
    }
}

