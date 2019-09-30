//
//  MasterTableViewCell.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/27/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    static let dateFormatter = DateFormatter()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var urlTextView: UITextField!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
