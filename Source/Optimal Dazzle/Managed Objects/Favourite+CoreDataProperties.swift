//
//  Favourite+CoreDataProperties.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/30/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var eventId: Int64

}
