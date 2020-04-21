//
//  ChangePasswordViewController.swift
//  Student App
//
//  Created by Kalyan Chakravarthy Mupparaju on 21/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet var currentPasswordField: UITextField!
    @IBOutlet var newPasswordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton_Action() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction() {
        
        guard let currentPass = currentPasswordField.text, currentPass.trimWhiteSpaces().count > 0 else {
                      self.showAlertWithTitleInView(title: "", message:"Please enter current password", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                      
                      return
                  }
        
        guard let newPass = newPasswordField.text, newPass.trimWhiteSpaces().count > 0 else {
            self.showAlertWithTitleInView(title: "", message:"Please enter new password", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
            return
        }
        
        if newPass != confirmPasswordField.text {
            self.showAlertWithTitleInView(title: "", message:"Password mismatch", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

        } else {
            
        
            guard let parentID = UserDefaults.standard.string(forKey: "parentEmail")
                       else { return print("No data") }
            let payload = ["newPassword":newPass, "email":parentID , "password":currentPass ] as [String : Any];
            

            SProgress.show()
            
            SAPIController.shared.changePasswordAPI(payload: payload) { (result, errorMessage) in
                print(" Response---- %@ /n %@", result,errorMessage)
                SProgress.hide()
                guard let jsonResponse = result as? [String: Any] else {
                                 return
                           }
                if let error = errorMessage {
                    
                    print("error message---- %@ /n %@", error)
                    self.showAlertWithTitleInView(title: "", message: error, buttonCancelTitle: "", buttonOkTitle: "OK"){
                                           (index) in
                                           
                                       }
                }else if jsonResponse["status"] as? String == "00"{
                    
                    self.showAlertWithTitleInView(title: "", message: "Password changed successfully", buttonCancelTitle: "", buttonOkTitle: "OK"){
                        (index) in
                        self.backButton_Action()
                    }
                    
                }else{
                    self.showAlertWithTitleInView(title: "", message: "Request failed. Please try again", buttonCancelTitle: "", buttonOkTitle: "OK"){
                                           (index) in
                                           
                                       }
                }
            }
            
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
