//
//  EventModel.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

struct EventsModel: Decodable {
    let events: [EventModel]
}

struct EventModel: Decodable {
    
    static let dateInputFormatter = DateFormatter()
    static let dateDisplayFormatter = DateFormatter()
    
    let title: String
    let id: UInt
    let localDateTime: Date    // "datetime_local": "2019-09-26T13:05:00"
    let eventTimeDisplayString: String
    var primaryPeformerImageUrl: URL?
    
    let performers: [PerformerModel]
    enum CodingKeys: String, CodingKey {
        case localDateTimeString = "datetime_local"
        case title
        case id
        case performers
    }
    
    init() {
        title = "An error occurred"
        id = 0
        localDateTime = Date.distantPast
        eventTimeDisplayString = "TBD"
        performers = []
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UInt.self, forKey: .id)
        print(self.id)
        title = try values.decode(String.self, forKey: .title)
        let dateString = try values.decode(String.self, forKey: .localDateTimeString)

        // Convert and save the display date once
        localDateTime = EventModel.dateInputFormatter.date(from: dateString) ?? Date.distantFuture
        eventTimeDisplayString = EventModel.dateDisplayFormatter.string(from: localDateTime)
        
        performers = try values.decode([PerformerModel].self, forKey: .performers)
        print(performers.count)
        
//        // Fetch the primary performer so we dont have to do it each time
//        if let pPerformer = (performers.filter { (p) -> Bool in
//            if p.primary {
//                return true
//            } else {
//                return false
//            }
//        }.first) {
//            // If there is a primary performer - extract its image url
//            self.primaryPeformerImageUrl = URL(string: pPerformer.imageUrl)
//        }
    }
}

//struct PerformersModel: Codable {
//    let performers: [PerformerModel]
//}

struct PerformerModel: Decodable {
    let image: String
    let primary: Bool

//    enum CodingKeys: String, CodingKey {
//        case imageUrl = "image"
//        case primary
//    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        primary = try values.decode(Bool.self, forKey: .primary)
//        imageUrl = try values.decode(String.self, forKey: .imageUrl)
//    }
}

//struct VenuModel: Decodable {
//    let displayLocation: String
//    enum CodingKeys: String, CodingKey {
//        case displayLocation = "display_location"
//    }
//}
