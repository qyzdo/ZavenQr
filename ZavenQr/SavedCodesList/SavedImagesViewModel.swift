//
//  SavedImagesViewModel.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import UIKit
import RxCocoa
import RxSwift

final class SavedImagesViewModel {
    private let disposeBag = DisposeBag()

    let images = PublishSubject<[SearchResultEntity]>()

    func fetchImages() {
        if let results = CoreDataHelper.shared.fetchData() {
            images.onNext(results)
        }
    }

    func deleteImage(index: Int) {
        CoreDataHelper.shared.deleteData(index: index)
        fetchImages()
    }
}
