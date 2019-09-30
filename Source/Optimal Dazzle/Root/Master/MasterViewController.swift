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
        
//        self.navigationItem.titleView = searchController.searchBar
//        searchController.searchBar.placeholder = "Search for an event"
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        
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
            
            viewController.masterViewController = self
            viewController.event = event
        }
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let event = self.viewModel.events[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as? MasterTableViewCell else {
                
                fatalError("Table view cell could not be created")
        }
        
        cell.titleLabel.text = event.title
        cell.dateLabel.text = event.eventTimeDisplayString
        cell.locationLabel.text = event.venue.displayLocation
        
        cell.favouriteImageView.isHidden = !FavouriteSession.shared.isFavourite(event.id)
        
        // Checks to see if the image is cahced. If not, launches the dowload queu
        // and in the mean time displays the default image. Once the image is
        // retrieved and the cell is still in focus, it will refresh. Checks to ensure
        // that the downloaded image is for the same event as the cell in case
        // its reused and out of sync.
        
        if let pathUrl = self.cacheUrl?.appendingPathComponent(event.imageHash) {
            if FileManager.default.fileExists(atPath: pathUrl.path) {
                do {
                    let imageData = try Data(contentsOf: pathUrl)
                    if !imageData.isEmpty {
                        cell.thumbnail.image = UIImage(data: imageData)
                    } else {
                        cell.thumbnail.image = UIImage(named: "default-image")
                    }
                } catch {
                    cell.thumbnail.image = UIImage(named: "default-image")
                }
            } else {
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
                            }
                        
                        } else {

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
    
    // Undo segue target
    @IBAction func unwindToMaster(segue:UIStoryboardSegue) {
        
    }
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
 
            }
        }
    
        // Launch an operation to prefetch the image and story on drive
        
    }
}

extension MasterViewController: UISearchBarDelegate {
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // Min two characters required
//        if searchText.count <= 1 {
//            return
//        }
        
        self.viewModel.result(forQuery: searchText, onComplete: { (query) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
}

