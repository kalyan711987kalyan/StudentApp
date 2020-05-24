//
//  SubjectViewController.swift
//  Student App
//
//  Created by kalyan on 11/01/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import AVKit

class WelcomeViewController: UIViewController {

    var websiteLink : String = ""
    var howtouseLink: String = ""
    var completion:(()->())?
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        viewButton.titleLabel?.adjustsFontSizeToFitWidth = true
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func redirectToWebsite() {
        guard let url = URL(string: websiteLink) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func redirectToVideo() {
//        let player = AVPlayer(url: URL(string: howtouseLink)!)
//                   let controller = AVPlayerViewController()
//                   controller.player = player
//
//                   // Modally present the player and call the player's play() method when complete.
//                   present(controller, animated: true) {
//                       player.play()
//                   }
        
        guard let url = URL(string: howtouseLink) else {
                 return //be safe
               }

               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
    }
    
    @IBAction func skipButtonAction() {
        completion?()
        self.dismiss(animated: true, completion: nil)
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
