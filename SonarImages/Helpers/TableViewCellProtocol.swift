//
//  TableViewCellProtocol.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import Combine

protocol TableViewCellProtocol {
    typealias Input<T> = PassthroughSubject<T, Never>
    typealias Output<K> = AnyPublisher<K, Never>
}

