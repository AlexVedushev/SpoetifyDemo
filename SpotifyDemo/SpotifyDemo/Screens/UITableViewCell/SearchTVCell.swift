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
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setup(name: String, imagePath: String? = nil) {
        nameLabel.text = name
        previewImageView.isHidden = true
        
        if let path = imagePath, let url = URL(string: path) {
            previewImageView.af_setImage(withURL: url)
            previewImageView.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
