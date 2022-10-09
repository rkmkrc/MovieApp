//
//  FavoriteMovie+CoreDataProperties.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 9.08.2022.
//
//

import Foundation
import CoreData


extension FavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }

    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var posterPath: String
    @NSManaged public var id: Int64
    @NSManaged public var imdb: Double
}

extension FavoriteMovie : Identifiable {}
