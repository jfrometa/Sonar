//
//  MockCore.swift
//  SonarImagesTests
//
//  Created by Jose Frometa on 24/10/22.
//

import Foundation
@testable import SonarImages

class MockCoreProtocol: CoreProtocol {
    init(){}
    var imagesRepository: ImagesRepository = MockimagesRepository()
}
