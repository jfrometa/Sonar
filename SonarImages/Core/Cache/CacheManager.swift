//
//  CacheManager.swift
//  SonarImages
//
//  Created by Jose Frometa on 22/10/22.
//

import UIKit

protocol CacheProtocol {
    func add(key: String, value: UIImage)
    func get(key: String) -> UIImage?
}

class CacheManager: CacheProtocol {
    static let instance = CacheManager()
    
    private init() { }
    
    private(set) var cache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString,  UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200
        
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
