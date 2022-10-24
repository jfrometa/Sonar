//
//  ImagesService.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit
import Combine

protocol ImagesRepository {
  func addToCache(key: String, image: UIImage)
  func fetchImage(from url: String) -> AnyPublisher<UIImage, NetworkingError>
  func fetchImagesURLS(page: Int, for input: String) -> AnyPublisher<ImagesResponse, NetworkingError>
}

class DefaultImagesRepository: ImagesRepository {
    let api: ImagesEndPoint
    let cache: CacheProtocol
    
    init(api: ImagesEndPoint, cache: CacheProtocol) {
        self.api = api
        self.cache = cache
    }

    func addToCache(key: String, image: UIImage) {
        self.cache.add(key: key, value: image)
    }
    
    func fetchImage(from url: String) -> AnyPublisher<UIImage, NetworkingError> {
        if let image = self.cache.get(key: url) {
            print("Returns:  CACHE")
            return  Result.Publisher(image).eraseToAnyPublisher()
        }

        return api.fetchImages(from: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImagesURLS(page: Int = 1,for input: String) -> AnyPublisher<ImagesResponse, NetworkingError> {
        return api
            .fetchImagesUrls(page: page, for: input)
           .catch { error in
               return Fail(error: error).eraseToAnyPublisher()
           }
           .eraseToAnyPublisher()
    }
}
