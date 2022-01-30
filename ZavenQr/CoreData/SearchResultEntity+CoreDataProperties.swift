//
//  SearchResultEntity+CoreDataProperties.swift
//  
//
//  Created by Oskar Figiel on 30/01/2022.
//
//

import Foundation
import CoreData

extension SearchResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResultEntity> {
        return NSFetchRequest<SearchResultEntity>(entityName: "SearchResultEntity")
    }

    @NSManaged public var searchedPhrase: String
    @NSManaged public var creationDate: Date
    @NSManaged public var photoUrl: String
    @NSManaged public var imageData: Data?

}
