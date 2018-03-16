//
//  SearchTVCell.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 15/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setup(name: String, temp: Double) {
        nameLabel.text = name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
