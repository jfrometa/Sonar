//
//  NetworkingError.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation

enum NetworkingError: Error {
    case serverError, timedOut, badUrl, endPoint(error: String), unknown
}
