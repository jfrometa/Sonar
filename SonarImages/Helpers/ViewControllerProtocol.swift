//
//  ViewControllerProtocol.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import Combine

protocol ViewControllerProtocol {
    typealias Input<T> = PassthroughSubject<T, Never>
    typealias Output<K> = AnyPublisher<K, Never>
}
