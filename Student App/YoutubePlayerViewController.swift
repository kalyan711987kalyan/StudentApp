//
//  YoutubePlayerViewController.swift
//  Student App
//
//  Created by Kalyan Chakravarthy Mupparaju on 24/05/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class YoutubePlayerViewController: UIViewController {

    @IBOutlet weak var playerView: WKYTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerView.load(withVideoId: "CUXuyfFVQEA")

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
