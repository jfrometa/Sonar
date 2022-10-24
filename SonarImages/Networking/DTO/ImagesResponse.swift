//
//  ImagesResponse.swift
//  SonarImages
//
//  Created by Jose Frometa on 23/10/22.
//

import Foundation

struct ImagesResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [UnplashDTO]
}
