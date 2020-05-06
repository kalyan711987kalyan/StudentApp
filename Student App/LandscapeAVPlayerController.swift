//
//  LandscapeAVPlayerController.swift
//  Student App
//
//  Created by kalyan chakravarthy on 05/05/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import AVKit

class LandscapeAVPlayerController: AVPlayerViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
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
