//
//  MainTabViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 18/08/2021.
//

import UIKit

class MainTabViewController: UITabBarController {

    let titleNav = "Inter Market"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.barStyle = .black
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        tabBar.tintColor = Colors.BarTint

        let controllers = getViewController(forViews: setViews())
        setViewControllers(controllers, animated: false)
    }
    
    func setViews() -> [TabControllers] {
        var views = [TabControllers]()
        views.append(TabControllers(identifier: SearchViewController.identifier, title: "Buscar", isHiddenBar: true, imageIcon: nil))
        views.append(TabControllers(identifier: CategoriesViewController.identifier, title: "Categorias", isHiddenBar: false, imageIcon: Icons.Categories))
        views.append(TabControllers(identifier: CartViewController.identifier, title: "Mi Carrito", isHiddenBar: false, imageIcon: nil))
        views.append(TabControllers(identifier: FavoritesViewController.identifier, title: "Favoritos", isHiddenBar: false, imageIcon: nil))
        views.append(TabControllers(identifier: OptionsViewController.identifier, title: "Mas", isHiddenBar: false, imageIcon: nil))
        return views
    }
    
    private func getViewController(forViews views: [TabControllers]) -> [UIViewController]? {
        var arrayViews = [UIViewController]()
        for i in 0...views.count - 1 {
            let controller = UIViewController(nibName: views[i].identifier, bundle: nil)
            controller.title = views[i].title
            controller.navigationItem.title = titleNav
            controller.tabBarItem.image = views[i].imageIcon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            controller.tabBarItem.selectedImage = views[i].imageIcon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            arrayViews.append(controller.embbededNavigationController(forHidden: views[i].isHiddenBar))
        }
        return arrayViews
    }
    
    func setupTabs(forIcons icons: UIImage, forTitleTab titleTab: String, forTitleNav titleNab: String, forIdentifier identifier: String) -> UIViewController {
        let tab = UIViewController(nibName: identifier, bundle: nil)
        tab.title = titleTab
        tab.navigationItem.title = titleNav
        tab.tabBarItem.image = icons.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        tab.tabBarItem.selectedImage = icons.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tab
    }
    
}
