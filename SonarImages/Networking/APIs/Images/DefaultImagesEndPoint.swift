//
//  ImagesEndPoint.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation
import Combine
import UIKit

public class DefaultImagesEndPoint: ImagesEndPoint {
    
  private let client: Client
  private let baseURL = "https://api.unsplash.com"
    
  init(client: Client) {
      self.client = client
  }

  func fetchImages(from url: String) -> AnyPublisher<UIImage, NetworkingError> {
      return self.client
          .call(.images, url: url, method: .GET)
          .tryMap { UIImage(data: $0, scale: 1)! }
          .mapError { error in NetworkingError.endPoint(error: error.localizedDescription) }
          .eraseToAnyPublisher()
  }
    
  func fetchImagesUrls(page: Int = 1, for input: String) -> AnyPublisher<ImagesResponse, NetworkingError> {
      let _input = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
      return self.client
          .call(.imagesCollection(page: page,input: _input), url: baseURL, method: .GET)
          .decode(type: ImagesResponse.self, decoder: JSONDecoder())
          .mapError { error in NetworkingError.endPoint(error: error.localizedDescription) }
          .eraseToAnyPublisher()
  }
}
