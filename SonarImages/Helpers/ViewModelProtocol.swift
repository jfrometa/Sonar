//
//  ViewModelType.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation
import Combine


protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    mutating func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
