//
//  SceneDelegate.swift
//  WeightControl
//
//  Created by Николай on 24.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = Colors.unselected
        tabBarController.tabBar.backgroundColor = Colors.tabBarBackground
        
        let chartController = UINavigationController(rootViewController: ChartViewController())
        let logController = UINavigationController(rootViewController: WeightLogTableViewController())
        let settingsController = UINavigationController(rootViewController: HumanParametersViewController())
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = Colors.barBackground
               
        for nc in [chartController, logController, settingsController] {
            nc.navigationBar.prefersLargeTitles = false
            nc.navigationBar.compactAppearance = appearance
            nc.navigationBar.scrollEdgeAppearance = appearance
            nc.navigationBar.tintColor = .white
        }
                
        tabBarController.setViewControllers([chartController, logController, settingsController], animated: false)
        
        guard let items = tabBarController.tabBar.items else { return }
        
        let itemsSettings = [
            (title: "Weight control", image: UIImage(systemName: "house.fill")),
            (title: "History", image: UIImage(systemName: "list.dash")),
            (title: "Settings", image: UIImage(systemName: "gearshape"))
        ]
        
        for index in 0..<items.count {
            items[index].image = itemsSettings[index].image
            items[index].title = itemsSettings[index].title
        }
        
        window?.rootViewController = tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

