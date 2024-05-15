import UIKit

class TabBarController: UITabBarController , UITabBarControllerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.delegate = self
        tabBar.backgroundColor = .systemRed
        tabBar.alpha = 1
        tabBar.layer.cornerRadius = 5
        
        let HomeViewController = UINavigationController(rootViewController: HomeViewController())
        HomeViewController.title = "Home Page"
        HomeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
      
        let FavoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        FavoritesViewController.title = "Favorites Page"
        FavoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        

        self.viewControllers = [HomeViewController, FavoritesViewController  ]

        self.selectedIndex = 0

    }


}

