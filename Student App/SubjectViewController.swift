//
//  SubjectViewController.swift
//  Student App
//
//  Created by kalyan on 11/01/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var popupView:UIView!

    var completion:(()->())?
    var downloadCompletion:(()->())?

    var isDownloading: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
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
    
    @IBAction func noButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func YesButtonAction() {
        
        if isDownloading {
            downloadCompletion?()
        }else{
            DispatchQueue.main.async {
                       self.indicator.startAnimating()
                       self.titleLabel.text = "Downloading..."

                   }
                  isDownloading = true
                   completion?()
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
