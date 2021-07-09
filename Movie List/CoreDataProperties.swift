//
//  CoreDataProperties.swift
//  Movie List
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import Foundation
import CoreData

extension MovieCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCoreData> {
        return NSFetchRequest<MovieCoreData>(entityName: "MovieCoreData")
    }

    @NSManaged public var genre: [String]?
    @NSManaged public var image: String?
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: Int64
    @NSManaged public var title: String?
   
}
