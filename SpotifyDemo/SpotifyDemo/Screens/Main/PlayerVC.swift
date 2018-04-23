//
//  PlayerVC.swift
//  SpotifyDemo
//
//  Created by Alexey Vedushev on 16/04/2018.
//  Copyright © 2018 Alexey Vedushev. All rights reserved.
//

import UIKit

class PlayerVC: UIViewController {

    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
