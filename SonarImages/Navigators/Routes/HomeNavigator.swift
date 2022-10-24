//
//  HomeNavigator.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

protocol HomeNavigator: NavigatorFactoryNavigableProtocol {
    func navigateHome()
    func navigateToImageDetails(url: String, image: UIImage)
}

final class DefaultHomeNavigator: HomeNavigator, UINavigatorProtocol {
    var navigatorFactory: NavigatorFactoryProtocol
    var navigationController: UINavigationController


    init(navigatorFactory: NavigatorFactoryProtocol,
         navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigatorFactory = navigatorFactory
    }

    func navigateHome() {
        let service = navigatorFactory.coreDependencies.imagesRepository
        let vm = HomeViewModel(navigator: self, imagesRepository: service)
        let vc = HomeViewController(viewModel: vm)

        self.navigationController.setToolbarHidden(true, animated: false)
        self.navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigateToImageDetails(url: String, image: UIImage) {
        let vm = ImageDetailsViewModel(url: url, image: image)
        let vc = ImageDetailsViewController(viewModel: vm)
        self.navigationController.pushViewController(vc, animated: true)
    }
    

    func dismiss(animated _: Bool) {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
}
