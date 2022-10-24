//
//  HomeView.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

class HomeView: UIView {
    
    let refreshButton: UIButton = {
      let button = UIButton(type: .system)
      button.setAttributedTitle("Refresh".font16(), for: .normal)
      button.tintColor = .black
      button.backgroundColor = .orange.withAlphaComponent(0.4)

      button.translatesAutoresizingMaskIntoConstraints = false

      return button
    }()
    
    let fetchButton: UIButton = {
      let button = UIButton(type: .system)
      button.setAttributedTitle("Fetch New Page".font16(), for: .normal)
      button.tintColor = .black
      button.backgroundColor = .orange.withAlphaComponent(0.4)

      button.translatesAutoresizingMaskIntoConstraints = false

      return button
    }()

    let tableView: UITableView = {
        let list = UITableView()
        list.isUserInteractionEnabled = true
        list.translatesAutoresizingMaskIntoConstraints = false
        //list.refreshControl = UIRefreshControl()
        list.backgroundColor = .systemBackground
        list.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        list.rowHeight = 300 //UITableView.automaticDimension
        list.estimatedRowHeight = 300
                
        list.separatorColor = .clear

        list.tableHeaderView = UIView(frame: .zero)
        list.tableHeaderView?.isHidden = true

        list.tableFooterView = UIView(frame: .zero)
        list.tableFooterView?.isHidden = true
        
        return list
    }()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return indicator
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()

        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    let searchBar: UISearchBar = {
       let search = UISearchBar()
        search.searchTextField.autocorrectionType = .no
        return search
    }()

   override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.setView()
        self.setConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        self.backgroundColor = .systemBackground
        
        self.searchBar.frame = .init(x: 0, y: 0, width: frame.size.width, height: 50)
       
        
        let buttons = UIStackView(arrangedSubviews: [refreshButton, fetchButton])
        buttons.axis = .horizontal
        buttons.spacing = 8
        
        self.container.addArrangedSubview(self.searchBar)
        self.container.addArrangedSubview(self.tableView)
        self.container.addArrangedSubview(buttons)

        self.addSubview(self.container)
    }
    
    private func setConstraints() {
        let width: CGFloat = UIScreen.main.bounds.width
        let widthWithPadding = width - 50

        NSLayoutConstraint.activate([
            searchBar.widthAnchor.constraint(equalToConstant: width),
            searchBar.heightAnchor.constraint(equalToConstant:  50)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.widthAnchor.constraint(equalToConstant:  widthWithPadding/2.3),
            refreshButton.heightAnchor.constraint(equalToConstant:  50)
        ])
        
        NSLayoutConstraint.activate([
            fetchButton.widthAnchor.constraint(equalToConstant:  widthWithPadding/2.3),
            fetchButton.heightAnchor.constraint(equalToConstant:  50)
        ])
        
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalToConstant: width)
        ])

        NSLayoutConstraint.activate([
            container
                .leadingAnchor.constraint(equalTo: leadingAnchor),
            container
                .trailingAnchor.constraint(equalTo: trailingAnchor),
            container
                .bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            container
                .topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
}
