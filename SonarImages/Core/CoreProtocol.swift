//
//  CoreProtocol.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation

protocol CoreProtocol {
    var imagesRepository: ImagesRepository { get }
}

class CoreImplementation: CoreProtocol {
    let imagesRepository: ImagesRepository

    init(imagesRepository: ImagesRepository) {
        self.imagesRepository = imagesRepository
    }
}
