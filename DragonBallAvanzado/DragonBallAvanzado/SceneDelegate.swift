//
//  SceneDelegate.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 24/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Splash", bundle: .main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
        rootViewController?.viewModel = SplashViewModel(
            apiProvider : ApiProvider(),
            keychainProvider: KeychainProvider())
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController ?? UIViewController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }



}

