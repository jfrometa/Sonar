//
//  Client.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit
import Combine

class DefaultClient: Client {
    func call(_ endPoint: Endpoint, url: String, method: Method) -> AnyPublisher<Data, NetworkingError> {
        let urlRequest = request(for: endPoint,url: url, method: method)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError{ _ in NetworkingError.serverError }
            .map { $0.data }
            .mapError { error in NetworkingError.endPoint(error: error.localizedDescription) }
            .eraseToAnyPublisher()
    }
    
    private func request(for endpoint: Endpoint, url: String, method: Method) -> URLRequest {
        let path = "\(url)\(endpoint.stringValue)"
        guard let url = URL(string: path)
            else { preconditionFailure("Bad URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        return request
    }
}
