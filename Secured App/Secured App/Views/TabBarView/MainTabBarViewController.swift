//
//  MainTabBarViewController.swift
//  Secured App
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.requestAlwaysAuthorization()
    }
}

private extension MainTabBarViewController {
    func setupView() {
        setupRootView()
        addTabs()
    }
    
    func setupRootView() {
        delegate = self
    }
    
    func addTabs() {
        var viewControllersArray = [UIViewController]()
        viewControllersArray.append(buildTab(viewController: HomeViewController(), title: "Filmy", image: UIImage(systemName: "film")!, selectedImage: UIImage(systemName: "film")!))
        viewControllersArray.append(buildTab(viewController: SearchViewController(), title: "Wyszukiwarka", image: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!))
        viewControllersArray.append(buildTab(viewController: ProfileViewController(), title: "Profil", image: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person")!))
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

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController.tabBarItem.title == "Profil" else { return true }
        
        if JailbreakDetectionService.isJailbroken() {
            let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            
            if let rootViewController = window?.rootViewController {
                let alertController = UIAlertController(title: "Twoje urządzenie ma złamane zabezpieczenia producenta", message: "W związku z tym logowanie jest niemożliwe", preferredStyle: .alert)
                alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
                
                rootViewController.present(alertController, animated: true)
            }
            
            return false
        }
        
        if AuthenticationManager.shared.getSessionToken() == nil {
            presentLoginViewController()
            return false
        }
        
        return true
    }
    
    private func presentLoginViewController() {
        let loginViewController = LoginViewController { [weak self] in
            guard let self = self else { return }
            
            if AuthenticationManager.shared.getSessionToken() != nil {
                self.selectedIndex = 2
            }
        }
        
        present(loginViewController, animated: true)
    }
}
