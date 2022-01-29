//
//  UnsplashModel.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 29/01/2022.
//

import Foundation

// MARK: - UnsplashModel
struct UnsplashModel: Codable {
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let id: String
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id, urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
