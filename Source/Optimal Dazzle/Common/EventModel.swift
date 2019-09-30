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
    let venue: VenuModel
    
    // The image will be cached with this name
    var imageHash: String = ""
    
    let performers: [PerformerModel]
    enum CodingKeys: String, CodingKey {
        case localDateTimeString = "datetime_local"
        case title
        case id
        case performers
        case location
        case venue
    }
    
    init() {
        title = "TBD"
        id = 0
        localDateTime = Date.distantPast
        eventTimeDisplayString = "TBD"
        performers = []
        venue = VenuModel(displayLocation: "TBD")
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(UInt.self, forKey: .id) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? "N/A"
        let dateString = try values.decodeIfPresent(String.self, forKey: .localDateTimeString) ?? ""
        localDateTime = EventModel.dateInputFormatter.date(from: dateString) ?? Date.distantFuture
        eventTimeDisplayString = EventModel.dateDisplayFormatter.string(from: localDateTime)
//        location = try values.decodeIfPresent(String.self, forKey: .location) ?? "TBD"
        performers = try values.decode([PerformerModel].self, forKey: .performers)
        venue = try values.decode(VenuModel.self, forKey: .venue)
        
        // Set the image-url so it is not done during fetch
        if let pPerformer = (performers.filter { (p) -> Bool in
            if p.primary {
                return true
            } else {
                return false
            }
        }.first) {
            // If there is a primary performer - extract its image url
            self.primaryPeformerImageUrl = URL(string: pPerformer.image)
            self.imageHash = "IMG"+String(pPerformer.image.hashValue)
            print(self.imageHash)
        }
    }
}

//struct PerformersModel: Codable {
//    let performers: [PerformerModel]
//}

struct PerformerModel: Decodable {
    let image: String
    let primary: Bool

    enum CodingKeys: String, CodingKey {
        case image
        case primary
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        primary = try values.decodeIfPresent(Bool.self, forKey: .primary) ?? false
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}

struct VenuModel: Decodable {
    let displayLocation: String
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}
