//
//  TabBarController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        tabBar.tintColor = .systemTeal
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.isTranslucent = false
        
        viewControllers = [
            createTabBarItem(tabBarTitle: "Folders".localize(), tabBarImage: "folders", viewController: FoldersController()),
            createTabBarItem(tabBarTitle: "Notes".localize(), tabBarImage: "notes", viewController: FolderController()),
            createTabBarItem(tabBarTitle: "Map".localize(), tabBarImage: "map", viewController: MapViewController())
        ]
    }
    
    func createTabBarItem(tabBarTitle: String, tabBarImage: String, viewController: UIViewController) -> UINavigationController {
            let navCont = UINavigationController(rootViewController: viewController)
            navCont.tabBarItem.title = tabBarTitle
            navCont.tabBarItem.image = UIImage(named: tabBarImage)

            navCont.navigationBar.tintColor = .systemBlue
            navCont.navigationBar.isTranslucent = false
            return navCont
        }
}
