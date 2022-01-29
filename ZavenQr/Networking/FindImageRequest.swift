//
//  FindImageRequest.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 29/01/2022.
//

import Foundation

class FindImageRequest: APIRequest {
    var method = RequestType.GET
    var path = "search/photos"
    var parameters = ["per_page" : "1"]

    init(name: String) {
        parameters["query"] = name
    }
}
