//
//  HomeTableViewCellModel.swift
//  SonarImages
//
//  Created by Jose Frometa on 22/10/22.
//

import UIKit
import Combine

class HomeTableViewCellModel: ViewModelProtocol {
    private let imagesRepository: ImagesRepository
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private(set) var cancelFetch: AnyCancellable?
    private(set) var url: String
    
    private(set) var image: UIImage? = nil
    private(set) var isLoading: Bool = false
    
    init(url: String, imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
        self.url = url
    }
    
    enum Input {
        case getImageForCell(imageSize: CGSize, scale: CGFloat)
    }
    
    enum Output {
        case fetchModelDidFail(error: Error)
        case fetchModelDidSucced(data: UIImage)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
            switch event {
            case let .getImageForCell(imageSize: CGSize, scale: CGFloat):
                guard let isLoading = self?.isLoading, !isLoading else { return  }
            
                self?.fetchImage(imageSize: CGSize, scale: CGFloat)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }

    
    func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
    
    func fetchImage(imageSize: CGSize, scale: CGFloat) {
        if isLoading {  print("IS LOADING: RETURN") ; return }
        self.isLoading = true
        
        print("IS LOADING:  CONTINUE")
        DispatchQueue.global(qos: .userInitiated).async() {
                    
            let fetch = self.imagesRepository
                .fetchImage(from: self.url)
                .map { [weak self] in
                  
                    guard
                          let url = URL(string: self!.url),
                          let downsampledLadyImage = self?.downsample( imageAt: url, to: imageSize)

                  else {
                      return $0
                  }
                    
                //   print("afterCompresion: \(image)")
                  guard let key = self?.url else { return downsampledLadyImage }
                    
                  self?.imagesRepository.addToCache(key: key, image: downsampledLadyImage)
                  return downsampledLadyImage
                }
                .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        self?.isLoading = false
                    case let .failure(error):
                        self?.isLoading = false
                        self?.output.send(.fetchModelDidFail(error: error))
                    }
                } receiveValue: { [weak self] data in
                    DispatchQueue.main.async() {
                        self?.image = data
                        self?.output.send(.fetchModelDidSucced(data: data))
                    }
                }
            
            self.cancelFetch = fetch
            fetch.store(in: &self.cancellables)
        }
    }
}
