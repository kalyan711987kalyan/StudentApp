//
//  RegisterViewController.swift
//  Student App
//
//  Created by kalyan on 25/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var parentNameTF: UITextField!
    @IBOutlet weak var contactNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var kidnameTF: UITextField!
    @IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var schoolNameTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var pinTF: UITextField!
    
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentNameTF.text = "ande"
        self.contactNumberTF.text = "1234567890"
        self.emailTF.text = "ande.gopimahesh@gmail.com"
        self.passwordTF.text = "123456"
        self.confirmPasswordTF.text = "123456"
        self.kidnameTF.text = "kid 1"
        self.schoolNameTF.text = "ande"
        self.classNameTF.text = "class"
        self.stateTF.text = "telanagana"
        self.cityTF.text = "hyd"
        self.pinTF.text = "123456"


        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
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
    @IBAction func registrationBtnAction(_ sender: Any) {
        
        guard let parentName = parentNameTF.text, parentName.trimWhiteSpaces().count > 0 else {
            self.showAlertWithTitleInView(title: "", message:"Please enter Parent Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
            return
        }
        guard let contactnumber = contactNumberTF.text, contactnumber.trimWhiteSpaces().count > 0 && (contactNumberTF.text!).count == 10 else {
            print("(contactNumberTF.text!).count is %@", (contactNumberTF.text!).count)

            if (contactNumberTF.text!).count < 10 || (contactNumberTF.text!).count > 10 {
                
              self.showAlertWithTitleInView(title: "", message:"Please enter a valid Contact Number.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

            }else{
                self.showAlertWithTitleInView(title: "", message:"Please enter Contact Number.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

            }
            return
        }
        guard let email = emailTF.text, email.trimWhiteSpaces().count > 0 && isValidEmail(email) else {
            if isValidEmail(emailTF.text!) == false {
                self.showAlertWithTitleInView(title: "", message:"Please enter Valid Email Address.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            }else{
                self.showAlertWithTitleInView(title: "", message:"Please enter Email Address.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            }
            return
        }
        guard let password = passwordTF.text, password.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter Password.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        guard let confirmpassword = confirmPasswordTF.text, confirmpassword.trimWhiteSpaces().count > 0 else {
            self.showAlertWithTitleInView(title: "", message:"Please enter Confirm Password.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
            return
        }
        
        let isEqual = (password == confirmpassword)

        if isEqual == false {
                 self.showAlertWithTitleInView(title: "", message:"Password and Confirm Password should be same.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                 return
             }
        
        guard let kidname = kidnameTF.text, kidname.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter Kid Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        guard let classname = classNameTF.text, classname.trimWhiteSpaces().count > 0 else {
            self.showAlertWithTitleInView(title: "", message:"Please enter Class Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
            return
        }
        guard let schoolname = schoolNameTF.text, schoolname.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter School Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        guard let state = stateTF.text, state.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter State.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        guard let city = cityTF.text, city.trimWhiteSpaces().count > 0 else {
            self.showAlertWithTitleInView(title: "", message:"Please enter City.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
            return
        }
        guard let pin = pinTF.text, pin.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter Pin.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        
        SProgress.show()
        
        
        let kidsData = [["className":classname , "school" : schoolname , "studentName" : kidname]];
        
        let registrationPayload = ["parentName":parentName, "email":email , "mobile":contactnumber , "city":city, "state":state , "pincode":pin , "password":confirmpassword , "kidsData": kidsData] as [String : Any];
        
        print("RegistrationregistrationPayload ",registrationPayload)

        
        
        SAPIController.shared.registrationAPI(payload: registrationPayload) { (result, errorMessage) in
            print("Login Response---- %@ /n %@", result,errorMessage)
            SProgress.hide()
            
            if let error = errorMessage {
                
                print("signup error message---- %@ /n %@", error)
                
            }else{
                
                self.showAlertWithTitleInView(title: "Congrats!", message: "Your account is created! Please Login. ", buttonCancelTitle: "", buttonOkTitle: "OK"){
                    (index) in
                    
                }
                return
                
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
