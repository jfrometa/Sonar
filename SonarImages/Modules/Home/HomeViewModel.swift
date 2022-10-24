//
//  HomeViewModel.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit
import Combine

class HomeViewModel: ViewModelProtocol {
    private let imagesRepository: ImagesRepository
    private let navigator: HomeNavigator
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private(set) var currentPage = 1
    
    private(set) var urls: [UnplashDTO] = [] {
        didSet {
            rowsViewModels = urls.map {
                HomeTableViewCellModel(
                    url: $0.urls.regular,
                    imagesRepository: self.imagesRepository)
            }
        }
    }
    
    private(set) var rowsViewModels: [HomeTableViewCellModel] = []
    
    init(navigator: HomeNavigator, imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
        self.navigator = navigator
    }
    
    enum Input {
        case viewDidAppear
        case refreshTrigger
        case search(input: String?)
        case fetchNextPage(input: String?)
    }
    
    enum Output {
        case fetchImagesDidFail(error:Error)
        case fetchImagedDidSucced(data: [UnplashDTO])
    }
    
    func cleanUrls() {
        urls = []
    }
    
    func navigateToImageDetails(url: String, image: UIImage) {
        self.navigator.navigateToImageDetails(url: url, image: image)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.fetchImagesUrls()
            case .refreshTrigger:
                self?.cleanUrls()
                self?.fetchImagesUrls()
            case let .search(input):
                guard let input = input else { return }
                self?.fetchImagesUrls(input)
            case let .fetchNextPage(input):
                self?.currentPage+=1
                
                guard let current = self?.currentPage else { return }
                
                guard let input = input, !input.isEmpty else {
                    self?.fetchImagesUrls(page: current)
                    return
                }
                
                self?.fetchImagesUrls(page: current, input)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func process(_ isNext: Bool, result: [UnplashDTO]) -> [UnplashDTO] {
        var processed: [UnplashDTO] = result
        
        if isNext && !self.urls.isEmpty {
            processed = self.urls + result
        }
        
        return processed
    }
    
    private func fetchImagesUrls(page: Int = 1, _ input: String = "computers") {
        self.imagesRepository
            .fetchImagesURLS(page: page, for: input)
            .sink { [weak self] completion in
            switch completion {
                case .finished:
                    print("imagesRepository finished successfully")
                case let .failure(error):
                    print("imagesRepository failed with error: \(error.localizedDescription)")
                    self?.output.send(.fetchImagesDidFail(error: error))
                }
            } receiveValue: { [weak self] image in
                self?.urls = self!.process(page > 1, result: image.results)
                self?.output.send(.fetchImagedDidSucced(data: image.results))
            }
            .store(in: &cancellables)
    }
}
