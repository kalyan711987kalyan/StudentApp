//
//  ViewController.swift
//  Student App
//
//  Created by kalyan on 23/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.slideMenuController()?.removeLeftGestures()
        self.userNameField.text = "ande.gopimahesh@gmail.com"
        self.passwordField.text = "123456"
    }

    @IBAction func loginButtonAction() {
           
           guard let username = userNameField.text, username.trimWhiteSpaces().count > 0 else {
               self.showAlertWithTitleInView(title: "", message:"Please enter username", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
               
               return
           }
          
           guard let password = passwordField.text, password.trimWhiteSpaces().count > 0 else {
               // alert for enter password
               self.showAlertWithTitleInView(title: "", message:"Please enter password", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
               return
           }
        SProgress.show()

           //self.userNameField.text = ""
           //self.passwordField.text = ""
        let loginPayload = ["email":username, "password":password]
        SAPIController.shared.loginAPI(payload: loginPayload) { (result, errorMessage) in
            print("Login Response---- %@ /n %@", result! as Any,errorMessage as Any)
            print("Login email---- %@ /n %@", result ,errorMessage)
            guard let jsonArray = result as? [String: Any] else {
                  return
            }
            //print(jsonArray)
            //Now get title value
            guard let parentEmail = jsonArray["email"] as? String else { return }
            print(parentEmail)
            UserDefaults.standard.set(parentEmail, forKey: "parentEmail") //Bool
            SProgress.hide()

            if let error = errorMessage {
                
            }else{
                
                self.performSegue(withIdentifier: SSegueKeys.login2dashboardKey, sender: result)
            }
        }
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
        if let response = sender as? [String:Any] {
            var kidsData: [KidObject] = []
            let kidsObj = response["kidsData"] as? [[String:Any]]
            kidsObj?.forEach({ (obj) in
                kidsData.append(KidObject(data: obj))
            })
           let parentData =  ParentObject(data: response)
            
            if #available(iOS 10.0, *) {
                if let tab = segue.destination as? UITabBarController, let nav = tab.viewControllers?.first as? UINavigationController, let vc = nav.viewControllers.first as? DashboardViewController
                {
                    vc.kidsList = kidsData
                    vc.parentObject = parentData
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
    }

}

