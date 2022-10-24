//
//  MockNavigationFactory.swift
//  SonarImagesTests
//
//  Created by Jose Frometa on 24/10/22.
//

import UIKit
@testable import SonarImages

class MockNavigatorFactory: NavigatorFactoryProtocol {
    init() {}
    
    var coreDependencies: CoreProtocol = MockCoreProtocol()
    
    func getHomeNavigator(navigationController: UINavigationController) -> HomeNavigator {
        MockHomeNavigator()
    }
}
