//
//  MainTabBarContoller.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 25.07.23.
//

import UIKit

class MainTabBarContoller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
        selectedIndex = viewControllers?.firstIndex(where: { $0 is StartViewController }) ?? 0
    }
   
    func generateTabBar() {
        viewControllers = [
            generateVC(viewController: SearchViewController(), image: UIImage(systemName: "magnifyingglass")),
            generateVC(viewController: StartViewController(), image: UIImage(systemName: "house.fill")),
            generateVC(viewController: FavoriteViewController(), image: UIImage(systemName: "star"))
        ]
    }

    func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        return viewController
    }

    func setTabBarAppearance() {
        tabBar.barTintColor = .black
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .red
    }
}
