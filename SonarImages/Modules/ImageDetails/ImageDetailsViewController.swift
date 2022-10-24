//
//  ImageDetailsViewController.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import UIKit
import Combine

class ImageDetailsViewController: UIViewController {
    private let viewModel: ImageDetailsViewModel
    private let input: Input<ImageDetailsViewModel.Input> = .init()
    private let mainView: ImageDetailsView = ImageDetailsView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ImageDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.title = "Image Details"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .black
    
        
        view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.input.send(.viewDidAppear)
    }
    
    private func bindViewModel() -> Void {
        let output: Output = viewModel
            .transform(input: input.eraseToAnyPublisher())
        
        output
          .receive(on: DispatchQueue.main)
          .sink { [weak self] event in
              switch event {
              case let .viewDidAppearDidTrigger(url, image):
                  self?.mainView.updateView(url: url, image: image)
              }
          }
          .store(in: &cancellables)
    }
}
