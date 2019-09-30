//
//  FavouriteSession.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/30/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation
import CoreData

class FavouriteSession {
    // Singleton to maintian favourites that are loaded
    // on initialization in a Set to allow O(1) during table retrieve
    
    // Signleton to avoid notifications across the app
    static let shared = FavouriteSession()
 
    var moc: NSManagedObjectContext?
    var favourites = Set<Int64>()
    
    private init() { }
    
    public func isFavourite(_ eventId: Int64) -> Bool {
        return self.favourites.contains(eventId)
    }
    
    // Call this once on App Initialization - Must call
    func setup(moc: NSManagedObjectContext) {
        
        self.moc = moc
        
        // Load the favourites from core data
        let request = NSFetchRequest<Favourite>(entityName: "Favourite" )
        request.predicate = NSPredicate(value: true)
        
        do {
            let result = try moc.fetch(request)
            for r in result {
                self.favourites.insert(r.eventId)
            }
        } catch {
            self.favourites.removeAll()
        }
    }
    
    /***
        Adds favourite and returns true on success
     */
    func addFavourite(_ eventId: Int64) -> Bool {
    
        guard let moc = self.moc else {
            print("MOC not available on add Favourtie")
            return false
        }
        
        if !self.favourites.contains(eventId) {
            guard
                let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: moc),
                let record = NSManagedObject(entity: entity, insertInto: moc) as? Favourite else {
                    
                    print("Could not create entity on new favourite")
                    return false
            }
            record.eventId = eventId
            
            do {
                try moc.save()
                self.favourites.insert(eventId)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return true
        }
    }
    
    /***
     Removes favourite and returns true on success.
     */
    func removeFavourite(_ eventId: Int64) -> Bool {
        
        let request = NSFetchRequest<Favourite>(entityName: "Favourite" )
        request.predicate = NSPredicate(format: "(eventId == %d)", eventId)
        guard let moc = self.moc else {
            print("MOC unavaibale on remove favourite")
            return false
        }
        if self.favourites.contains(eventId) {
            do {
                let result = try moc.fetch(request)
                // Remove the object and when done remove from cache
                for r in result {
                    moc.delete(r)
                }
                
                try moc.save()
                self.favourites.remove(eventId)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return true
        }
    }

}
