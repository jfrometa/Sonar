//
//  SonarImagesTests.swift
//  SonarImagesTests
//
//  Created by Jose Frometa on 21/10/22.
//

import XCTest
import Combine
@testable import SonarImages

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var home: HomeViewController!

    override func setUpWithError() throws {
        self.viewModel = HomeViewModel(
           navigator: MockHomeNavigator(),
           imagesRepository: MockimagesRepository()
       )
        self.home = HomeViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.home = nil
    }

    func testExample() throws {

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            viewModel.fetchImagesUrls()
        }
    }

}









