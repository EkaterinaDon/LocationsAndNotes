//
//  Note+CoreDataClass.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//
//

import UIKit
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    
    class func newNote(name: String, inFolder: Folder?) -> Note {
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        newNote.name = name
        newNote.dateUpdate = NSDate() as Date
        
        if let inFolder = inFolder {
            newNote.folder = inFolder
        }
        return newNote
    }
    
    var imageActual: UIImage? {
        set {
            if newValue == nil {
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!)
                }
                self.imageSmall = nil
            } else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                }
                self.image?.imageBig = newValue!.jpegData(compressionQuality: 1)
                self.imageSmall = newValue!.jpegData(compressionQuality: 0.05)
            }
            dateUpdate = Date()
        }
        get {
            if self.image != nil {
                if image?.imageBig != nil {
                    return UIImage(data: self.image!.imageBig!)
                }
            }
            return nil
        }
    }

    var locationActual: LocationCoordinate? {
        get {
            if self.location == nil {
                return nil
            } else {
                return LocationCoordinate(lat: self.location!.lat, lon: self.location!.lon)
            }
        }
        set {
            if newValue == nil && self.location != nil {
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
            } else if newValue != nil && self.location != nil {
                self.location?.lat = newValue!.lat
                self.location?.lon = newValue!.lon
            } else if newValue != nil && self.location == nil {
                let newLocation = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                newLocation.lat = newValue!.lat
                newLocation.lon = newValue!.lon
                self.location = newLocation
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.sharedInstance.getCurrentLocation { (location) in
            self.locationActual = location
            print(location)
        }
    }
    
    func addImage(image: UIImage) {
        let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
        imageNote.imageBig = image.jpegData(compressionQuality: 1)
        self.image = imageNote
    }
    
    func addLocation(latitude: Double, lontitude: Double) {
        let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.lat = latitude
        location.lon = lontitude
        self.location = location
    }
    
    var dateUpdateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self.dateUpdate!)
    }
}
