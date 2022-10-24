//
//  ImageDetailsViewModel.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import UIKit
import Combine

class ImageDetailsViewModel: ViewModelProtocol {
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let url: String
    private let image: UIImage

    init(url: String, image: UIImage) {
        self.url = url
        self.image = image
    }
    
    enum Input {
        case viewDidAppear
    }
    
    enum Output {
        case viewDidAppearDidTrigger(url: String, image: UIImage)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event { 
                case .viewDidAppear:
                    self.output.send(.viewDidAppearDidTrigger(url: self.url, image: self.image))
                }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
