//
//  Event+CoreDataProperties.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var timestamp: NSDate?

}
