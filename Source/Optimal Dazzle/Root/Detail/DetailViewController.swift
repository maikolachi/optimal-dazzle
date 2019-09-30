//
//  DetailViewController.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/25/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

//    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filledHeartButton: UIButton!
    @IBOutlet weak var emptyHeartButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    weak var masterViewController: MasterViewController?
    
    var viewModel = DetailViewViewModel()
    
    func configureView() {
        
        // On smaller format (non iPad) this is called first when
        // none of the controls are loaded. Called again after the segue.
        
        // On tablets, the controls are all loaded so this works without
        // segue.
        
        guard
            let event = self.event,
            let titleLabel = self.titleLabel,
            let locationLabel = self.locationLabel,
            let dateLabel = self.dateLabel else {
                return
        }
        titleLabel.text = event.title
        locationLabel.text = event.venue.displayLocation
        dateLabel.text = event.eventTimeDisplayString
        
        if let imageData = self.viewModel.image(forEvent: event) {
            self.mainImageView.image = UIImage(data: imageData)
        } else {
            self.mainImageView.image = UIImage(named: "event-default")
        }
        
        if FavouriteSession.shared.isFavourite(event.id) {
            self.filledHeartButton.isHidden = false
            self.emptyHeartButton.isHidden = true
        } else {
            self.filledHeartButton.isHidden = true
            self.emptyHeartButton.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true 
        // Do any additional setup after loading the view.
        configureView()
    }

    var event: EventModel? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    @IBAction func emptyHeartTouched(_ sender: UIButton) {
        if FavouriteSession.shared.addFavourite(self.event?.id ?? 0) {
            // Was added
            self.emptyHeartButton.isHidden = true
            self.filledHeartButton.isHidden = false
            self.masterViewController?.tableView.reloadData()
        }
    }
    
    @IBAction func filledHeartTouched(_ sender: UIButton) {
        if FavouriteSession.shared.removeFavourite(self.event?.id ?? 0) {
            // Successfully removed
            self.emptyHeartButton.isHidden = false
            self.filledHeartButton.isHidden = true
            self.masterViewController?.tableView.reloadData()
        }
    }
    

}

