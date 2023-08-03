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
        
            viewControllers = [generateVC(viewController: ViewController(), image: UIImage(systemName: "house.fill")), generateVC(viewController: InfoAboutMoviesViewController(), image: UIImage(systemName: "star"))]//generateVC(viewController: <#T##UIViewController#>, image: <#T##UIImage?#>)]
        }

        func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
            viewController.tabBarItem.image = image
            return  viewController
        }

        func setTabBarAppearance() {
            tabBar.backgroundColor = .white
            tabBar.tintColor = UIColor.red
            tabBar.unselectedItemTintColor = UIColor.gray
        }

}
