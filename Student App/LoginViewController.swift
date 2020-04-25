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
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var versionLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let flag = UserDefaults.standard.bool(forKey: "LoginFlag")
                     
        if flag == true {
            if let response =  UserDefaults.standard.value(forKey: "parentData") as? [String:Any] {
                self.performSegue(withIdentifier: SSegueKeys.login2dashboardKey, sender: response)
            }

        }
        
        self.slideMenuController()?.removeLeftGestures()
        //self.userNameField.text = "ande.gopimahesh@gmail.com"
        //self.passwordField.text = "123456"
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        self.versionLB.text = "V \(appVersion ?? "")"
        
       
    }

    @IBAction func forgetPwdBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
                      vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

                  self.present(vc, animated: true, completion: nil)

        
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
           // print("Login Response---- %@ /n %@", result! as Any)
           // print("Login email---- %@ /n %@", result)
            
            SProgress.hide()

            guard let jsonArray = result as? [String: Any] else {
                  return
            }
            print(jsonArray)
            //Now get title value
            guard let parentEmail = jsonArray["email"] as? String else {
                 self.showAlertWithTitleInView(title: "", message:jsonArray["reason"] as? String ?? "Login failed" , buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                return }
            guard let parentId = jsonArray["id"] as? String else { return }

            print(parentEmail)
            UserDefaults.standard.set(parentEmail, forKey: "parentEmail") //string
            UserDefaults.standard.set(parentId, forKey: "parentId") //string
            UserDefaults.standard.set(true, forKey: "LoginFlag") //Bool



            if let error = errorMessage {
                
                self.showAlertWithTitleInView(title: "", message:error, buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

                
            }else{
                
                
                UserDefaults.standard.set(result, forKey: "parentData")

                self.performSegue(withIdentifier: SSegueKeys.login2dashboardKey, sender: result)
            }
        }
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
        if let response = sender as? [String:Any] {
            var kidsData: [KidObject] = []
            if let kidsObj = response["kidsData"] as? [[String:Any]]{
                kidsObj.forEach({ (obj) in
                    kidsData.append(KidObject(data: obj))
                })
            }else if let kidsObj = response["kidsData"] as? [String:Any] {
                kidsData.append(KidObject(data: kidsObj))
            }
            
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

