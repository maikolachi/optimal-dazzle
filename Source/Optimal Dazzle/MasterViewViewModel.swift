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
    
    func cachedResult(forQuery: String, onComplete:  @escaping (([Event]) -> Void))  {
        // Bacground fetch
        self.persistentContainer?.performBackgroundTask({ (moc) in
            let request = NSFetchRequest<Event>(entityName: "Event" )
            request.predicate = NSPredicate(format: "(title like %@)", forQuery)
            do {
                let result = try moc.fetch(request)
                onComplete(result)
            } catch {
                // No callback to ignore fetch
            }
        })
    }
    
    /***
     On complete send back the result of the query and the querystring,
     query sting is used to invalidate the return if it does not match what is in the
     search bar.
    **/
    func result(forQuery query: String, onComplete: @escaping ((String) -> Void))  {
        print("New Search: \(query)")
        
        if query.count <= 3 {
            // Dont change anything that is displayed
            return
        }
        
        // Resubmit the query - not caching as search criteria is not clear
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
    
    
//    var fetchedResultsController: NSFetchedResultsController<Event> {
//        if _fetchedResultsController != nil {
//            return _fetchedResultsController!
//        }
//
//        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
//
//        // Set the batch size to a suitable number.
////        fetchRequest.fetchBatchSize = 20
//
//        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
//        aFetchedResultsController.delegate = self
//        _fetchedResultsController = aFetchedResultsController
//
//        do {
//            try _fetchedResultsController!.performFetch()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//
//        return _fetchedResultsController!
//    }
//    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

//    @objc
//    func insertNewObject(_ sender: Any) {
//        let context = self.fetchedResultsController.managedObjectContext
////        let newEvent = Event(context: context)
//
//        // If appropriate, configure the new managed object.
////        newEvent.timestamp = Date()
//
//        // Save the context.
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
//    func event(at indexPath: IndexPath) -> EventModel {
//        guard let queryResult =  queryResult else {
//            return  EventModel()
//        }
////        queryResult[safe: 2]
//        return queryResult[safe: indexPath.row] ?? EventModel()
//    }
    
//    var numberOfObjects: Int {
//        
////        guard let section = self.fetchedResultsController.sections?.first else {
////            return 0
////        }
////        return section.numberOfObjects
//        
//        return 10
//    }
//    
//    var objects: [Event] {
//
//        guard let events = self._fetchedResultsController?.fetchedObjects else {
//            return []
//        }
//        return events
//    }
    
    let clientId = "MTgzNTg2MTJ8MTU2OTQ2OTgyMC41Nw"
    let clientSecret = "082c8be00a3f5872aee37b02180970780e15725c532fd3c1d5ed69d7cda97c20"
}
