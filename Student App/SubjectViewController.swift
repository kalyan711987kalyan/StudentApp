//
//  SubjectViewController.swift
//  Student App
//
//  Created by kalyan on 11/01/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var completion:(()->())?
    var downloadCompletion:(()->())?

    var isDownloading: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
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
