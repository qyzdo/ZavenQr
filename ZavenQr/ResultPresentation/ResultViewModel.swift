//
//  ResultViewModel.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import Foundation
import UIKit

final class ResultViewModel {
    let isFromScanner: Bool
    private let model: SearchResultEntity

    init(isFromScanner: Bool, model: SearchResultEntity) {
        self.isFromScanner = isFromScanner
        self.model = model
    }

    func getMainLabelText() -> String {
        if isFromScanner {
            return "Found"
        } else {
            return model.searchedPhrase
        }
    }

    func getSecondLabelText() -> String {
        if isFromScanner {
            return """
            "\(model.searchedPhrase)"
            """
        } else {
            return model.photoUrl
        }
    }

    func getButtonTitleText() -> String {
        if isFromScanner {
            return "Save"
        } else {
            return "Close"
        }
    }

    func getImage() -> UIImage {
        if let imageData = model.imageData, let image = UIImage(data: imageData) {
            return image
        } else {
            return UIImage(systemName: "xmark.octagon.fill")!
        }
    }

}
