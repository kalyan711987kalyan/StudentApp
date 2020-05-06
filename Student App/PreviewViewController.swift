//
//  PreviewViewController.swift
//  Student App
//
//  Created by kalyan chakravarthy on 05/05/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var imageview: UIImageView!
    @IBOutlet var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

    }
    
    @IBAction func closeButtionAction() {
        
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
           // handling code
           self.dismiss(animated: true, completion: nil)
           
       }
       
       // MARK: UIGestureRecognizerDelegate methods, You need to set the delegate of the recognizer
       func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if touch.view?.isDescendant(of: popupView) == true {
               return false
            }
            return true
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
