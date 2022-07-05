//
//  ViewController.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupVCs()
    }
    
    func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: EmojisViewController(), title: NSLocalizedString("Emoji", comment: ""), image: UIImage(systemName: "face.smiling.fill")!),
            createNavController(for: UserViewController(), title: NSLocalizedString("Пользователи", comment: ""), image: UIImage(systemName: "person.fill")!)
        ]
    }
}
