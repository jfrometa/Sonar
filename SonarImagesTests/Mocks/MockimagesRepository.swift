//
//  MockimagesRepository.swift
//  SonarImagesTests
//
//  Created by Leo Salazar on 24/10/22.
//

import Combine
import UIKit
@testable import SonarImages

class MockimagesRepository: ImagesRepository {
    init() { value = nil ; value2 = nil  }
    
    func addToCache(key: String, image: UIImage) {

    }
    
    func fetchImage(from url: String) -> AnyPublisher<UIImage, NetworkingError> {
        return value ?? Empty().eraseToAnyPublisher()
    }
    
    func fetchImagesURLS(page: Int, for input: String) -> AnyPublisher<ImagesResponse, NetworkingError> {
        return Empty().eraseToAnyPublisher()
    }

//
//    func fetchImagesURLS(page: Int, for input: String) -> AnyPublisher<ImagesResponse, NetworkingError> {
//        return value2?
//            .sink(receiveValue: {
//                return ImagesResponse(total: 10, total_pages: 2, results: [
//                    .init(id: "id", urls:
//                        .init(
//                            regular: <#T##String#>,
//                            small: <#T##String#>,
//                            thumb: <#T##String#>)
//                    ),
//                ])
//        })
//        .mapError { Fail(error: $0).eraseToAnyPublisher() }
       
    
    let value: AnyPublisher<UIImage, NetworkingError>?
    let value2: AnyPublisher<ImagesResponse, NetworkingError>?

}
