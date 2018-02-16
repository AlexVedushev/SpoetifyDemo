//
//  PlayListTVCell.swift
//  Spotify Demo
//
//  Created by Alexey Vedushev on 13/02/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit
import AlamofireImage

class TrackTVCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(track: SPTPartialTrack) {
        trackNameLabel.text = track.name
        artistNameLabel.text = track.album.name
        coverImageView.af_setImage(withURL: track.previewURL)
    }
    
    func setup(name: String, artistName: String, previewURL: String) {
        trackNameLabel.text = name
        artistNameLabel.text = artistName
        
        if let url = URL(string: previewURL) {
            coverImageView.af_setImage(withURL: url)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
