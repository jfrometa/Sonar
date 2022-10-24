//
//  ImagesEndPoint.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import Combine
import UIKit

protocol ImagesEndPoint {
    func fetchImages(from url: String) -> AnyPublisher<UIImage, NetworkingError> 
    func fetchImagesUrls(page: Int, for input: String) -> AnyPublisher<ImagesResponse, NetworkingError>
}
