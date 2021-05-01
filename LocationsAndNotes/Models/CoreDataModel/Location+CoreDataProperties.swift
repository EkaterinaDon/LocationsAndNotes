//
//  Location+CoreDataProperties.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var note: Note?

}

extension Location : Identifiable {

}
