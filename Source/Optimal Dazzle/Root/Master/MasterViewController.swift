//
//  MasterViewController.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
//    var eventsModel: EventsModel?
    
    let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    
    var cacheUrl: NSURL?
    
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    // Container instead of moc to have ability to perform background
    // thread actions.
    var persistentContainer: NSPersistentContainer? = nil {
        didSet {
            self.viewModel.persistentContainer = self.persistentContainer
        }
    }
    
    var viewModel = MasterViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cacheUrl = NSURL(fileURLWithPath: self.docPath)
        self.tableView.prefetchDataSource = self
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.placeholder = "Search for an event"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = controllers.last as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to-detail" {
            guard
                let indexPath = tableView.indexPathForSelectedRow,
                let event = self.viewModel.events[safe: indexPath.row],
                let viewController = segue.destination as? DetailViewController else {
                    return
            }
            
            viewController.event = event
        }
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of sections called: \(self.viewModel.events.count)")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows called: \(self.viewModel.events.count)")
        return self.viewModel.events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Cell for row called: \(indexPath.row)")
        
        guard
            let event = self.viewModel.events[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as? MasterTableViewCell else {
                
                fatalError("Table view cell could not be created")
        }
        
        cell.titleLabel.text = event.title
        cell.dateLabel.text = event.eventTimeDisplayString
        cell.locationLabel.text = event.venue.displayLocation
        
        // Checks to see if the image is cahced. If not, launches the dowload queu
        // and in the mean time displays the default image. Once the image is
        // retrieved and the cell is still in focus, it will refresh. Checks to ensure
        // that the downloaded image is for the same event as the cell in case
        // its reused and out of sync.
        
        if let pathUrl = self.cacheUrl?.appendingPathComponent(event.imageHash) {
            if FileManager.default.fileExists(atPath: pathUrl.path) {
                print("Cache Available: \(pathUrl.path)")
                do {
                    let imageData = try Data(contentsOf: pathUrl)
                    if !imageData.isEmpty {
                        cell.thumbnail.image = UIImage(data: imageData)
                    } else {
                        print("Image data is invalid")
                        cell.thumbnail.image = UIImage(named: "default-image")
                    }
                } catch {
                    print("Image read crashed")
                    cell.thumbnail.image = UIImage(named: "default-image")
                }
            } else {
                print("Not Available: \(pathUrl.path)")
                if let url = event.primaryPeformerImageUrl {
                    
                    let operation = ImageDownloadOperation(fileName: event.imageHash,
                                                       imageUrl: url,
                                                       eventId: event.id)
                    operation.onComplete = { (eid, imageData) in
                        
                        // Ensure it is the same cell
                        if event.id == eid {
                            DispatchQueue.main.async {
                                cell.thumbnail.image = UIImage(data: imageData)
                                cell.setNeedsDisplay()
                                print("Image refreshed")
                            }
                        
                        } else {
                            print("Wrong image refreshed")
                        }
                    }
                    operation.qualityOfService = .background
                    operation.queuePriority = .normal
                    self.viewModel.imageDownloadQueue.addOperation(operation)
                }
                cell.thumbnail.image = UIImage(named: "default-image")
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    @IBAction func unwindToMaster(segue:UIStoryboardSegue) {
        
    }
    

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected")
//    }
    
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = fetchedResultsController.managedObjectContext
//            context.delete(fetchedResultsController.object(at: indexPath))
//
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
        cell.textLabel!.text = event.timestamp!.description
    }

    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//            case .insert:
//                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//            case .delete:
//                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//            default:
//                return
//        }
//    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//            case .insert:
//                tableView.insertRows(at: [newIndexPath!], with: .fade)
//            case .delete:
//                tableView.deleteRows(at: [indexPath!], with: .fade)
//            case .update:
//                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
//            case .move:
//                configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
//                tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//    }

//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}

extension MasterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        // Queue all these images to download
        
        for indexPath in indexPaths {
            if  let event = self.viewModel.events[safe: indexPath.row],
                let url = event.primaryPeformerImageUrl {
                let operation = ImageDownloadOperation(fileName: event.imageHash, imageUrl: url, eventId: event.id)
                
                operation.qualityOfService = .background
                operation.queuePriority = .normal
                self.viewModel.imageDownloadQueue.addOperation(operation)
            } else {
                print("Index path \(indexPath.row) event not found")
            }
        }
    
        
        // Launch an operation to prefetch the image and story on drive
        
    }
}

extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    
        // Search only when more than three characters entered and nothing
        // has been searched yet
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText.count <= 1 {
            return
        }
        
        self.viewModel.result(forQuery: searchText, onComplete: { (query) in
            print("New Images received: \(self.viewModel.events.count)")
//            self.eventsModel = events
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }

}

