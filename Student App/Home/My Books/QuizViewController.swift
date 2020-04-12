//
//  QuizViewController.swift
//  Student App
//
//  Created by kalyan on 12/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    var allQuizQuestions : NSArray = []

    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var qestionNumber: UILabel!
    
    @IBAction func optionA(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("allQuizQuestions",allQuizQuestions)
        
        

        // Do any additional setup after loading the view.
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
