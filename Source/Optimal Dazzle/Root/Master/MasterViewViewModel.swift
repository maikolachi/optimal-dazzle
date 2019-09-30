//
//  MasterViewViewModel.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MasterViewViewModel: NSObject {

    var events: [EventModel] = [EventModel]()
    
    var persistentContainer: NSPersistentContainer? = nil
    private var urlSession = URLSession(configuration: .default)
    private var sessionDataTask: URLSessionDataTask?
    
    private var queryURLComponents = URLComponents(string: "https://api.seatgeek.com/2/events") ?? URLComponents()
    private var queryItems = [URLQueryItem]()
    private let jsonDecoder = JSONDecoder()
    
    // Set of event id's loaded for the mster view to provide O(1)
    var favourites = Set<Int64>()
    
    lazy var imageDownloadQueue: OperationQueue = {
      var queue = OperationQueue()
      queue.name = "Image Download"
      queue.maxConcurrentOperationCount = 2
      return queue
    }()
    
    override init() {
        super.init()
        
        self.queryItems.append(contentsOf: [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "client_secret", value: self.clientSecret)
        ])
        
    }

    /***
     On complete send back the result of the query and the querystring,
     query sting is used to invalidate the return if it does not match what is in the
     search bar.
    **/
    func result(forQuery query: String, onComplete: @escaping ((String) -> Void))  {
     
        self.queryURLComponents.queryItems = self.queryItems + [URLQueryItem(name: "q", value: query)]
       
        guard let url = self.queryURLComponents.url else {
            return
        }
        
        self.sessionDataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Data error \(error.localizedDescription)")
            } else if let data = data {
                do {
                    if let jsonModel = try self?.jsonDecoder.decode(EventsModel.self, from: data) {
                        self?.events = jsonModel.events
                        onComplete(query)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        self.sessionDataTask?.resume()
    }
    
    let clientId = "MTgzNTg2MTJ8MTU2OTQ2OTgyMC41Nw"
    let clientSecret = "082c8be00a3f5872aee37b02180970780e15725c532fd3c1d5ed69d7cda97c20"
}
