//
//  Aplication.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

final class Application {
    static let shared = Application()
    
    private(set) var window: UIWindow?
    private(set) var navigationController = UINavigationController()
    private let navigatorFactory: NavigatorFactoryProtocol

    private init() {
        self.navigatorFactory = NavigatorFactory.instance
    }

    func configure(in window: UIWindow) {
        self.window = window
        self.window?.backgroundColor = .white
              
        self.navigatorFactory
            .getHomeNavigator(navigationController: self.navigationController)
            .navigateHome()
    
        UIView
            .transition(with: window, duration: 0, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let navigationController = self?.navigationController else { return }
            window.rootViewController = navigationController
        }, completion: { _ in
            window.makeKeyAndVisible()
        })
    }
}
