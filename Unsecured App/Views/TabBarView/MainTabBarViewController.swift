//
//  MainTabBarViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension MainTabBarViewController {
    func setupView() {
        addTabs()
    }
    
    func addTabs() {
        var viewControllersArray = [UIViewController]()
        viewControllersArray.append(buildTab(viewController: HomeViewController(), title: "Filmy", image: UIImage(systemName: "film")!, selectedImage: UIImage(systemName: "film.fill")!))
        viewControllersArray.append(buildTab(viewController: SearchViewController(), title: "Wyszukiwarka", image: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!))
        viewControllersArray.append(buildTab(viewController: LoginViewController(), title: "Profil", image: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person.fill")!))
        viewControllers = viewControllersArray
    }
}

private extension MainTabBarViewController {
    func buildTab(viewController: UIViewController, title: String?, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
}
