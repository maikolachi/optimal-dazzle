//
//  EventModel.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

struct EventsModel: Codable {
    let events: [EventModel]
}

struct EventModel: Codable {
    let title: String
    let id: UInt
    
}

struct PerformersModel: Codable {
    let performers: [PerformerModel]
}

struct PerformerModel: Codable {
    let image: String
    let primary: Bool
    let slug: String
    let home_team: Bool
}

struct VenuModel: Codable {
    let display_location: String
    let datetime_local: Date    // "datetime_local": "2019-09-26T13:05:00"
}
