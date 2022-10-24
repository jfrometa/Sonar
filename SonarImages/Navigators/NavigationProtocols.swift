//
//  NavigationProtocols.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import UIKit

protocol NavigatorFactoryNavigableProtocol {
    var navigatorFactory: NavigatorFactoryProtocol { get }
    
    func dismiss(animated: Bool)
}

protocol UINavigatorProtocol {
    var navigationController: UINavigationController { get set }
}
