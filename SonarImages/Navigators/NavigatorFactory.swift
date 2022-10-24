//
//  NavigatorFactory.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

protocol NavigatorFactoryProtocol {
    var coreDependencies: CoreProtocol { get }
    
    func getHomeNavigator(navigationController: UINavigationController) -> HomeNavigator
}

final class NavigatorFactory: NavigatorFactoryProtocol {
    
    private(set) var coreDependencies: CoreProtocol
    static let instance = NavigatorFactory()
    
    private init() {
        let imagesRepository = DefaultImagesRepository(
            api: DefaultImagesEndPoint(client: DefaultClient()), cache: CacheManager.instance
        )
        self.coreDependencies = CoreImplementation(imagesRepository: imagesRepository)
    }
    
    func getHomeNavigator(navigationController: UINavigationController) -> HomeNavigator {
        DefaultHomeNavigator(navigatorFactory: self, navigationController: navigationController)
    }
}
