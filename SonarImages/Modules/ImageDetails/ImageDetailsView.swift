//
//  ImageDetailsView.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import UIKit

class ImageDetailsView: UIView {
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
        lbl.attributedText = "text_is_empty".font12()
        return lbl
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

        self.container.addArrangedSubview(self.imageV)
        self.container.addArrangedSubview(self.lblTitle)
        
        self.addSubview(self.container)
    }
    
    private func setConstraints() {
        let width: CGFloat = UIScreen.main.bounds.width
        let widthWithPadding = width - 50

        NSLayoutConstraint.activate([
            lblTitle.widthAnchor.constraint(equalToConstant: widthWithPadding),
            lblTitle.heightAnchor.constraint(equalToConstant:  100)
        ])
        
        NSLayoutConstraint.activate([
            imageV.widthAnchor.constraint(equalToConstant:  widthWithPadding),
            imageV.heightAnchor.constraint(equalToConstant:  500)
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
    
    func updateView(url: String, image: UIImage){
        self.lblTitle.attributedText = url.font16(.darkGray)
        self.imageV.image = image
    }

}
