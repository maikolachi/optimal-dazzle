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
    let localDateTime: Date    // "datetime_local": "2019-09-26T13:05:00"
    enum CodingKeys: String, CodingKey {
        case localDateTime = "datetime_local"
        case title
        case id
    }
    
    init() {
        title = "An error occurred"
        id = 0
        localDateTime = Date.distantFuture
    }
}

struct PerformersModel: Decodable {
    let performers: [PerformerModel]
}

struct PerformerModel: Decodable {
    let image: String
    let primary: Bool
    let slug: String
    let homeTeam: Bool
    
    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case image
        case primary
        case slug
    }
}

struct VenuModel: Decodable {
    let displayLocation: String
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}
