//
//  MainViewController.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit



class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func didTapButton() {
        let tabBarVC = TabBar()
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}

