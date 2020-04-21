//
//  ForgetPasswordViewController.swift
//  Student App
//
//  Created by kalyan on 20/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var fprgetPwdTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var getOTPbTN: UIButton!
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendOtpBtn(_ sender: Any) {
        guard let email = fprgetPwdTF.text, email.trimWhiteSpaces().count > 0 && isValidEmail(email) else {
               if isValidEmail(fprgetPwdTF.text!) == false {
                   self.showAlertWithTitleInView(title: "", message:"Please enter Valid Email Address.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
               }else{
                   self.showAlertWithTitleInView(title: "", message:"Please enter Email Address.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
               }
               return
            
        }
        
            SProgress.show()
        
            let baseURLString = APIEndPoints.base.urlString
            
            guard let url = URL(string: baseURLString+"/API/LoginAPI/forgotPassword?email="+email) else {
                //completion(nil)
                return
            }
        
            Alamofire.request(url,
                              method: .get,
                              parameters: ["include_docs": "true"])
                .validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                       // print("Error while fetching remote rooms: \(String(describing: response.result.error)")
                        //completion(nil)
                        SProgress.hide()

                        return
                    }
                    
                    if let reason = response as? [String:Any] {
                        
                        print("reason" ,reason["reason"] as! String )
                        
                        self.showAlertWithTitleInView(title: "Failed", message:"Please try agian after sometime!", buttonCancelTitle:"", buttonOkTitle: "Ok"){ (index) in
                        }

                    }
                    
                    
                    if let response = response.result.value as? [String:Any] {
                        
                        self.showAlertWithTitleInView(title: "", message:(response["reason"] as? String)!, buttonCancelTitle:"", buttonOkTitle: "Ok"){ (index) in
                        }
                    }
                    
                  
                    
                   
                    SProgress.hide()

                    print("response",response)
            }
        
        
        
        
        
        
     }
    
    func isValidEmail(_ email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
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
