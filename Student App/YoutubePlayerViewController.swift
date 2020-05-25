//
//  YoutubePlayerViewController.swift
//  Student App
//
//  Created by Kalyan Chakravarthy Mupparaju on 24/05/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var videoId:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.delegate = self
        // Do any additional setup after loading the view.
        playerView.load(withVideoId: videoId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate!.orientation = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }

    override func viewWillDisappear(_ animated: Bool) {
           appDelegate!.orientation = .portrait
           UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        if state == .ended {
            self.backAction()
        }
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
