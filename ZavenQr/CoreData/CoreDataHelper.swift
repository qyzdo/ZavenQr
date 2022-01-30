//
//  CoreDataHelper.swift
//  ZavenQr
//
//  Created by Oskar Figiel on 30/01/2022.
//

import Foundation
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchData() -> [SearchResultEntity]? {
        do {
            return try self.context.fetch(SearchResultEntity.fetchRequest())
        } catch {
            //Should log error here
        }

        return nil
    }

    func saveData(model: SearchResultEntity) {
        context.insert(model)
        do {
            try self.context.save()
        } catch {
            //Should log error here
        }
    }

    func deleteData(index: Int) {
        guard let data = fetchData() else { return }
        context.delete(data[index])

        do {
            try self.context.save()
        } catch {
            //Should log error here
        }
    }

    func createModel(searchedPhrase: String, photoUrl: String) -> SearchResultEntity {
        let model = SearchResultEntity(searchedPhrase: searchedPhrase, photoUrl: photoUrl, creationDate: Date(), context: nil)
        return model
    }
}
