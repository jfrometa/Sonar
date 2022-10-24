//
//  ClientProtocol.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation
import Combine

protocol Client {
    func call(_ endPoint: Endpoint, url: String, method: Method) -> AnyPublisher<Data, NetworkingError>
}
