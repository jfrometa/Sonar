//
//  HomeViewController.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let input: Input<HomeViewModel.Input> = .init()
    private let mainView: HomeView = HomeView()
    private var cancellables = Set<AnyCancellable>()
    
    //apple recomendation.
    private let serialQueue = DispatchQueue(label: "downsample queue")
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.title = "Sonar Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        view = self.mainView
        
        self.mainView.searchBar.delegate = self
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        self.mainView.tableView.prefetchDataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !(mainView.searchBar.text?.isEmpty ?? false) {
            self.mainView.reloadTableView()
            return
        }
        
        self.input.send(.viewDidAppear)
    }
    
    @objc
    private func refreshButtonTapped() {
        if let searchText = mainView.searchBar.text, !searchText.isEmpty {
            self.performSearchFetch()
            return
        }
        input.send(.refreshTrigger)
    }
    
    @objc
    private func fetchNextPage() {
        guard let searchText = mainView.searchBar.text else { return }
        input.send(.fetchNextPage(input: searchText))
    }

    private func bindViewModel() -> Void {
        let output: Output = viewModel
            .transform(input: input.eraseToAnyPublisher())
        
        output
          .receive(on: DispatchQueue.main)
          .sink { [weak self] event in
              switch event {
              case let .fetchImagedDidSucced(result):
                  guard !result.isEmpty else { self?.showAlert() ; return }
                  self?.mainView.reloadTableView()
                  
              case let .fetchImagesDidFail( error):
                  DispatchQueue.main.asyncAfter(deadline: .now()) {  [weak self] in
                      self?.showAlert()
                  }
                 
                  print("fetchImagesDidFail: \(error)")
              }
          }
          .store(in: &cancellables)

        self.mainView.refreshButton
            .addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        
        self.mainView.fetchButton
            .addTarget(self, action: #selector(fetchNextPage), for: .touchUpInside)
    }
}

extension HomeViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Sorry! no results",
                                      message: "we couldnt find photos at this time",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 100.0 {
            self.fetchNextPage()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: HomeTableViewCell.identifier, for: indexPath
            ) as? HomeTableViewCell else {
           return UITableViewCell()
       }
        
        let cellViewModel = viewModel.rowsViewModels[indexPath.row]
        
        print("configuration INIT: \(indexPath.row)")
        cell.configure(using: cellViewModel) { [weak self] in
            print("configuration complete: \(indexPath.row)")
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !viewModel.rowsViewModels.isEmpty else { return }
        
        indexPaths.forEach { indexPath in
            guard let cell = tableView
                 .dequeueReusableCell(
                     withIdentifier: HomeTableViewCell.identifier, for: indexPath
                 ) as? HomeTableViewCell else {
                return
            }
             
             let cellViewModel = viewModel.rowsViewModels[indexPath.row]
            
             
            let scale = tableView.traitCollection.displayScale
            let size = cell.frame.size.width
  
            serialQueue.async {
                cellViewModel
                    .fetchImage(imageSize: .init(width: size, height: 400), scale: scale)
            }
        }
     
        print("did prefectch")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {

        indexPaths.forEach { [weak self] indexPath in
            self?.viewModel.rowsViewModels[indexPath.row].cancelFetch?.cancel()
        }
        
        print("did cancel prefetch")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dismisses keyboard
        UIApplication.shared
            .sendAction(
                #selector(UIApplication.resignFirstResponder),
                to: nil, from: nil, for: nil
            );
        
        let cellViewModel = viewModel.rowsViewModels[indexPath.row]
        guard let image = cellViewModel.image else { return }
        
        self.viewModel.navigateToImageDetails(url: cellViewModel.url, image: image)
    }
}

extension HomeViewController: UISearchBarDelegate {
    private func performSearchFetch() {
        if let query = mainView.searchBar.text, !query.isEmpty {
            self.viewModel.cleanUrls()
            self.mainView.reloadTableView()
            
            self.input.send(.search(input: query))
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.performSearchFetch()
    }
}
