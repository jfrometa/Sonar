//
//  HomeTableViewCell.swift
//  SonarImages
//
//  Created by Jose Frometa on 22/10/22.
//

import UIKit
import Combine

class HomeTableViewCell: UITableViewCell {
    static let identifier: String = "HomeTableViewCell"

    private let input: Input<HomeTableViewCellModel.Input> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private var viewModel: HomeTableViewCellModel?
    
    let imageV: UIImageView = {
        let image = UIImageView()
        
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .orange.withAlphaComponent(0.2)
        
        image.layer.cornerRadius = 14
        image.tintColor = .black

        return image
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.attributedText = "text_".font12()
        return lbl
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()

        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loading = UIActivityIndicatorView(style: .large)
    
    func showLoading() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        loading.hidesWhenStopped = true
     
        
        addSubview(loading)
        loading.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        loading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    func stopLoading() {
        loading.stopAnimating()
        loading.removeFromSuperview()
    }
    
    override func prepareForReuse() {
        self.stopLoading()
        
        super.prepareForReuse()
        self.lblTitle.text = nil
        self.imageV.image = nil
        self.viewModel = nil
        self.cancellables = .init()
    }
    
    private func setView() {
        self.container.addArrangedSubview(self.imageV)
        self.container.addArrangedSubview(self.lblTitle)

        self.contentView.addSubview(container)
        self.contentView.backgroundColor = .white
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            container
                .leadingAnchor.constraint(equalTo: leadingAnchor),
            container
                .trailingAnchor.constraint(equalTo: trailingAnchor),
            container
                .bottomAnchor.constraint(equalTo: bottomAnchor),
            container
                .topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageV
                .widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            imageV
                .heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            lblTitle
                .widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            lblTitle
                .heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
  
    private var completionBlock: ((UIImage) -> ())?
    
    func configure(using viewModel: HomeTableViewCellModel, completion: @escaping () -> ()) {
        self.cancellables = Set<AnyCancellable>()
        self.viewModel = viewModel
        self.lblTitle.text = viewModel.url

        self.completionBlock = { [weak self]  image in
            DispatchQueue.main.asyncAfter(deadline: .now()) {  [weak self] in
                self?.imageV.image = image
                self?.imageV.layoutIfNeeded()
                completion()
            }
        }
        
        if let image = self.viewModel?.image {
            completionBlock?(image)
        }
        
        self.showLoading()
        
        let output: Output = self.viewModel!.transform(input: input.eraseToAnyPublisher())
        let scale = self.traitCollection.displayScale
        
        guard imageV.image == nil else { return }

        output
            .sink(receiveValue: { [weak self] data in
                switch data {
                case .fetchModelDidFail(error: let error):
                    self?.stopLoading()
                    print("error: \(error)")
                case .fetchModelDidSucced(data: let image):
                    self?.completionBlock?(image)
                    self?.completionBlock = nil
                    self?.stopLoading()
                }
            })
            .store(in: &cancellables)
        
        input.send(.getImageForCell(imageSize: imageV.bounds.size, scale: scale))
    }    
}
