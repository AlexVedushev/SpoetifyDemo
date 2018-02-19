//
//  PlayListTVCell.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import AlamofireImage

class PlayListTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(listName: String, trackCount: Int, imageURi: URL) {
        nameLabel.text = listName
        trackCountLabel.text = "\(trackCount)"
        coverImageView.af_setImage(withURL: imageURi)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
