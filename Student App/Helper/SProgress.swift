//
//  VProgress.swift
//  Vidyat
//
//  Created by Narendra Kumar R on 5/4/18.
//  Copyright © 2018 Maya.Ninja LLC. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD
class SProgress: NSObject {
    static func show() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
        }
    }
    static func hide() {
         DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    static func show(in view: UIView, message: String? = nil) {
        DispatchQueue.main.async {
            
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.bezelView.color = UIColor.clear
            
            if let message = message {
                hud.label.text = message;
            }
            hud.mode = .indeterminate;
        }
    }
    static func hide(in view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
