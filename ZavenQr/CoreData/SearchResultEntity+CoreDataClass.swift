//
//  SearchResultEntity+CoreDataClass.swift
//  
//
//  Created by Oskar Figiel on 30/01/2022.
//
//

import Foundation
import CoreData

@objc(SearchResultEntity)
public class SearchResultEntity: NSManagedObject {
    convenience init(searchedPhrase: String, photoUrl: String, creationDate: Date, imageData: Data?, context: NSManagedObjectContext?) {

        let entity = SearchResultEntity.entity()
        self.init(entity: entity, insertInto: context)

        self.searchedPhrase = searchedPhrase
        self.photoUrl = photoUrl
        self.creationDate = creationDate
        self.imageData = imageData
    }
}
