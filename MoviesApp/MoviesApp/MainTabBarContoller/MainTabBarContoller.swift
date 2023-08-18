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
    }
    
    func generateTabBar() {
        
            viewControllers = [
                generateVC(viewController: SearchViewController(), image: UIImage(systemName: "magnifyingglass")),
                generateVC(viewController: ViewController(), image: UIImage(systemName: "house.fill"))]
        }

        func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
            viewController.tabBarItem.image = image
            return  viewController
        }

        func setTabBarAppearance() {
            tabBar.barTintColor = .black
            tabBar.unselectedItemTintColor = .gray
            tabBar.tintColor = .red
        }
}
