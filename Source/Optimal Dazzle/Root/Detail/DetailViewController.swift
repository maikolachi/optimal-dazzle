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
    
    func configureView() {
        guard
            let event = self.event else {
                return
        }
        print(event.title)
        self.titleLabel?.text = event.title
        self.locationLabel?.text = event.venue.displayLocation
        self.dateLabel?.text = event.eventTimeDisplayString

        
        // Download the image and display
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.timestamp!.description
//            }
//        }
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


}

