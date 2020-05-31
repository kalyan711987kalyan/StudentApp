//
//  QuizViewController.swift
//  Student App
//
//  Created by kalyan on 12/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController {
    var allQuizQuestions : NSArray = []
    
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var qestionNumber: UILabel!
    @IBOutlet weak var questionTextA: UIButton!
    @IBOutlet weak var questionTextB: UIButton!
    @IBOutlet weak var questionTextC: UIButton!
    
    
    @IBOutlet weak var prevBtnOutlet: UIButton!
    @IBOutlet weak var nextBtnOutet: UIButton!
    var selectedIndex : Int = 0
    var questionPageIndex : Int = 0
    var pageData = [String:Any]()
    let synthesizer = AVSpeechSynthesizer()

    @IBOutlet var ButtonCollection: [UIButton]!
    @IBAction func optionA(_ sender: UIButton) {
        ButtonCollection.forEach({$0.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)})
        ButtonCollection.forEach({$0.backgroundColor = #colorLiteral(red: 0.883149147, green: 0.6980459094, blue: 0.2709751725, alpha: 1)})
        sender.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sender.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        selectedIndex = sender.tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("allQuizQuestions",allQuizQuestions)
        prevBtnOutlet.isHidden = true
        nextBtnOutet.isHidden = true
        
        pageData = allQuizQuestions[questionPageIndex] as! [String : Any]
        self.qestionNumber.text = "\(questionPageIndex+1)"
        
        self.updateQuestionAnswers(dict: pageData)

      /*  self.question?.text = pageData["question"]! as? String
        self.questionTextA.setTitle(pageData["option1"]! as? String, for: UIControl.State.normal)
        self.questionTextB.setTitle(pageData["option2"]! as? String, for: UIControl.State.normal)
        self.questionTextC.setTitle(pageData["option3"]! as? String, for: UIControl.State.normal)*/
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAnswerBtn(_ sender: Any) {
        
        if selectedIndex == 5 {
             self.showAlertWithTitleInView(title: "", message:"Please select Answer!", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index)
                           in
                           
                       }
            return
        }
        
        
        
        let answer = pageData["answer_key"]! as! String
        let answerType:Int? = Int(answer)!-1 // firstText is UITextField
        
        if (selectedIndex ==  answerType){
            print("Correct")
            ButtonCollection[selectedIndex].backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            ButtonCollection[selectedIndex].tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            
            self.showAlertWithTitleInView(title: "", message:"Correct!", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index)
                in
                
            }
            selectedIndex = 5
            nextBtnOutet.isHidden = false
            //questionPageIndex += 1
            // showDataByPage()
            self.playTextToSpeech(text: "Correct answer")

            
            
        }else{
            
            self.showAlertWithTitleInView(title: "", message:"Wrong!", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index)
                in
                
            }
            self.playTextToSpeech(text: "Wrong answer")

        }
    }
    @IBAction func showNextQuestion(_ sender: Any) {
        questionPageIndex += 1
        showDataByPage()
        
        if questionPageIndex >= 1 {
            prevBtnOutlet.isHidden = false
        }else{
            prevBtnOutlet.isHidden = true
        }
        nextBtnOutet.isHidden = true
    }
    
    @IBAction func showPreviousQestion(_ sender: Any) {
        questionPageIndex -= 1
        showDataByPage()
        
        if questionPageIndex >= 1 {
            prevBtnOutlet.isHidden = false
        }else{
            prevBtnOutlet.isHidden = true
        }
    }
    
    @IBAction func playTextToAudio() {
        pageData = allQuizQuestions[questionPageIndex] as! [String : Any]
        let qust = pageData["question"] as? String ?? ""
        self.playTextToSpeech(text: qust)
    }
    
    func playTextToSpeech(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
               
        synthesizer.speak(utterance)
    }
    func showDataByPage(){
        pageData.removeAll()
        ButtonCollection.forEach({$0.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)})
        ButtonCollection.forEach({$0.backgroundColor = #colorLiteral(red: 0.883149147, green: 0.6980459094, blue: 0.2709751725, alpha: 1)})
        pageData = allQuizQuestions[questionPageIndex] as! [String : Any]
        self.qestionNumber.text = "\(questionPageIndex)"
        self.updateQuestionAnswers(dict: pageData)
        /*self.question?.text = pageData["question"]! as? String
        self.questionTextA.setTitle(pageData["option1"]! as? String, for: UIControl.State.normal)
        self.questionTextB.setTitle(pageData["option2"]! as? String, for: UIControl.State.normal)
        self.questionTextC.setTitle(pageData["option3"]! as? String, for: UIControl.State.normal)*/
    }
    
    func updateQuestionAnswers(dict: [String:Any]) {
        
        let q = pageData["question"]! as? String
        self.question?.text = q

        let q1 = pageData["option1"]! as? String ?? ""
        let q2 = pageData["option2"]! as? String ?? ""
        let q3 = pageData["option3"]! as? String ?? ""

        let arrayString = q1.components(separatedBy:".")
        if arrayString.last == "png" || arrayString.last == "jpeg"{
            var searchURL : NSURL = NSURL(string: q1 as String)!
            self.questionTextA.load(url: searchURL as URL)
            self.questionTextA.imageView?.contentMode = .scaleAspectFit

            searchURL = NSURL(string: q2 as String)!
            self.questionTextB.load(url: searchURL as URL)
            self.questionTextB.imageView?.contentMode = .scaleAspectFit

             searchURL = NSURL(string: q3 as String)!
            self.questionTextC.load(url: searchURL as URL)
            self.questionTextC.imageView?.contentMode = .scaleAspectFit

        }else{
            self.questionTextA.setTitle(q1, for: UIControl.State.normal)
                          
            self.questionTextB.setTitle(q2, for: UIControl.State.normal)
                          
            self.questionTextC.setTitle(q3, for: UIControl.State.normal)
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
