//
//  RegisterViewController.swift
//  Student App
//
//  Created by kalyan on 25/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class RegisterViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

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
    var kidsData: [[String:String]] = [[ : ]]

    @IBOutlet weak var selectCls: UIButton!
    @IBAction func selectClassBTN(_ sender: Any) {
        let classNameArray = [" Nursery", " LKG", " UKG", " I", " II", " III", " IV", " V", " VI", " VII"," VIII"," IX"," X"]
                      self.showPopoverActionSheet(listArray: classNameArray ,tag: 1 ,title: "Select Class" )

    }
    func showPopoverActionSheet (listArray : Array<String>, tag : Int , title : String){
             let alertController = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
             for item in listArray{
                 let superbutton = UIAlertAction(title: "\(item)" , style: .default, handler: { (action) in
                     print("\(item)")
                   self.selectCls.setTitle(item, for: .normal)
                   //self.kidClassTF.text = item
                 })
                 alertController.addAction(superbutton)
             }

             self.present(alertController, animated: true, completion: nil)
         }
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentNameTF.text = "lucky"
        self.contactNumberTF.text = "1234567890"
        self.emailTF.text = "lucky.gopimahesh@gmail.com"
        self.passwordTF.text = "123456"
        self.confirmPasswordTF.text = "123456"
        self.kidnameTF.text = "kid 1"
        self.schoolNameTF.text = "ande"
      //  self.classNameTF.text = "class"
        self.stateTF.text = "telanagana"
        self.cityTF.text = "hyd"
        //self.pinTF.text = "123456"
        
        //add corner radiuso
        self.addcornerRadious(textfiled: parentNameTF)
       self.addcornerRadious(textfiled: contactNumberTF)
        self.addcornerRadious(textfiled: emailTF)
       self.addcornerRadious(textfiled: passwordTF)
        self.addcornerRadious(textfiled: confirmPasswordTF)
        self.addcornerRadious(textfiled: kidnameTF)
        self.addcornerRadious(textfiled: schoolNameTF)
        //self.addcornerRadious(textfiled: classNameTF)
        self.addcornerRadious(textfiled: stateTF)
        self.addcornerRadious(textfiled: cityTF)
       // self.addcornerRadious(textfiled: stateTF)

            self.parentNameTF.setLeftPaddingPoints(10)
        self.contactNumberTF.setLeftPaddingPoints(10)
        self.emailTF.setLeftPaddingPoints(10)
        self.passwordTF.setLeftPaddingPoints(10)
        self.confirmPasswordTF.setLeftPaddingPoints(10)
        self.kidnameTF.setLeftPaddingPoints(10)
        self.schoolNameTF.setLeftPaddingPoints(10)
        self.stateTF.setLeftPaddingPoints(10)
        self.cityTF.setLeftPaddingPoints(10)

        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        selectCls.layer.cornerRadius = 15.0
        selectCls.layer.borderWidth = 2.0
        selectCls.layer.borderColor = UIColor.black.cgColor

    }
    
    func addcornerRadious(textfiled : UITextField){
        textfiled.layer.cornerRadius = 15.0
        textfiled.layer.borderWidth = 2.0
        textfiled.layer.borderColor = UIColor.black.cgColor
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
        guard let classname = self.selectCls.titleLabel!.text, classname.trimWhiteSpaces().count > 0 else {
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
//        guard let pin = pinTF.text, pin.trimWhiteSpaces().count > 0 else {
//            // alert for enter password
//            self.showAlertWithTitleInView(title: "", message:"Please enter Pin.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
//            return
//        }
        
        SProgress.show()
       let results = self.appDelegate!.getAllRecordsforValue(valueof: "", forattribute: "", forEntity: "KidsData")
        
        if results.count > 0{
            for result in results {
                
                let populatedDictionary = ["kidClass": result.value(forKey: "kidClass") as? String ,"school": result.value(forKey: "kidSchool") as? String, "studentName": result.value(forKey: "kidName") as? String]
                
                self.kidsData.append(populatedDictionary as! [String : String])
            }
            let dict = ["className":classname , "school" : schoolname , "studentName" : kidname] as! [String:String]
            self.kidsData.append(dict)
        }else{
            self.kidsData = [["className":classname , "school" : schoolname , "studentName" : kidname]];

        }
        
        let registrationPayload = ["parentName":parentName, "email":email , "mobile":contactnumber , "city":city, "state":state , "pincode":"000000" , "password":confirmpassword , "kids": kidsData] as [String : Any];
        
        print("RegistrationregistrationPayload ",registrationPayload)

        SAPIController.shared.registrationAPI(payload: registrationPayload) { (result, errorMessage) in
            print("Login Response---- %@ /n %@", result,errorMessage)
            SProgress.hide()
            guard let jsonArray = result as? [String: Any] else {
                             return
                       }
            if let error = errorMessage {
                self.showAlertWithTitleInView(title: "", message:error, buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

                print("signup error message---- %@ /n %@", error)
                
            }else if (jsonArray["status"] as? String ?? "") == "00" {
                self.appDelegate!.deleteAllDataOfEntity(forEntity: "KidsData")

                self.showAlertWithTitleInView(title: "Congrats!", message: "Your account is created! Please Login. ", buttonCancelTitle: "", buttonOkTitle: "OK"){
                    (index) in
                    
                }
                
            }else{
               let error =  jsonArray["reason"] as? String ?? "Signup failed."
                self.showAlertWithTitleInView(title: "", message: error, buttonCancelTitle: "", buttonOkTitle: "OK"){
                    (index) in
                    
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func addKids(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddKidViewController") as! AddKidViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func showKids(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageKidsViewController") as! ManageKidsViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

        self.present(vc, animated: true, completion: nil)

        
    }
}
