//
//  ImageNote+CoreDataProperties.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//
//

import Foundation
import CoreData


extension ImageNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageNote> {
        return NSFetchRequest<ImageNote>(entityName: "ImageNote")
    }

    @NSManaged public var imageBig: Data?
    @NSManaged public var note: Note?

}

extension ImageNote : Identifiable {

}
