//
//  SceneDelegate.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let application = Application.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        let _window = UIWindow(windowScene: winScene)
        
        // ignores the user theme settings and enforces .lightMode
        if #available(iOS 13.0, *) {
            _window.overrideUserInterfaceStyle = .light
        }
        
        self.application.configure(in: _window)
        self.window = _window
    }
}


