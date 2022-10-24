//
//  MockHomeNavigator.swift
//  SonarImagesTests
//
//  Created by Jose Frometa on 24/10/22.
//

import UIKit
@testable import SonarImages

class MockHomeNavigator: HomeNavigator {

    init() {}
    
    var navigatorFactory: NavigatorFactoryProtocol = MockNavigatorFactory()
    
    func navigateHome() {
        print("did navigate home")
    }
    
    func navigateToImageDetails(url: String, image: UIImage) {
        print("did navigate navigateToImageDetails")
    }

    func dismiss(animated: Bool) {
        print("did dissmis")
    }
}
