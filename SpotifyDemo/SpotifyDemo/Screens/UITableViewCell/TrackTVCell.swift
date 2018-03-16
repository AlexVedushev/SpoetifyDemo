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
    struct  Data {
        let position: Int
        let name: String
        let artistName: String
        let durationStr: String
        let bpm: Double
    }
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(data: Data){
        positionLabel.text = "\(data.position)"
        trackNameLabel.text = data.name
        artistNameLabel.text = data.artistName
        durationLabel.text = data.durationStr
        bpmLabel.text = "bpm: \(Int(data.bpm))"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
