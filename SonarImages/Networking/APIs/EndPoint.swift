//
//  EndPoint.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import Foundation


enum Endpoint {
    case images
    case imagesCollection(page: Int, input: String)
}

extension Endpoint {
    var stringValue: String {
        switch self {
        case .images:
            return "/photos?/300300"
        case let .imagesCollection(page, input):
            return "/search/photos?page=\(page)&per_page=30&query=\(input)&client_id=cgcfn53Vi70pyvdjQAE6jPP6GQwiC_nCg_uNzGWTavk"
        }
    }
}

enum Method: String {
    case GET
}
