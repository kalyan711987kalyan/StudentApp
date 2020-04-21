//
//  AddKidViewController.swift
//  Student App
//
//  Created by kalyan on 07/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class AddKidViewController: UIViewController  , UITextFieldDelegate {
    @IBOutlet weak var kidNameTF: UITextField!
   // @IBOutlet weak var kidClassTF: UITextField!
    @IBOutlet weak var kidSchoolTF: UITextField!
    @IBOutlet weak var classBtnOutlet: UIButton!
    
    var kid_id = ""
    var kidName = String()
    var kidSchool = String()
    var kidClass = String()
    var mode = String()

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
       // kidClassTF.delegate = self
        // Do any additional setup after loading the view.
        
        self.kidNameTF.text = kidName
        self.kidSchoolTF.text = kidSchool
        self.classBtnOutlet.setTitle(kidClass, for: .normal)
    
        
    }
    @IBAction func classBTNAction(_ sender: Any) {
        let classNameArray = [" Nursery", " LKG", " UKG", " I", " II", " III", " IV", " V", " VI", " VII"," VIII"," IX"," X"]
                      self.showPopoverActionSheet(listArray: classNameArray ,tag: 1 ,title: "Select Class" )
    }
    private func textFieldDidBeginEditing(textField: UITextField) {
       // kidClassTF.resignFirstResponder()
        //call your function here
       
    }
   
    func showPopoverActionSheet (listArray : Array<String>, tag : Int , title : String){
          let alertController = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
          for item in listArray{
              let superbutton = UIAlertAction(title: "\(item)" , style: .default, handler: { (action) in
                  print("\(item)")
                self.classBtnOutlet.setTitle(item, for: .normal)
                //self.kidClassTF.text = item
              })
              alertController.addAction(superbutton)
          }

          self.present(alertController, animated: true, completion: nil)
      }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func randomString(kidname: String , kidclass: String , kidschool : String) -> String {
      let letters = "\(kidname)\(kidclass)\(kidschool)"
      return String((0..<30).map{ _ in letters.randomElement()! })
    }
    @IBAction func addKidBtnAction(_ sender: Any) {
        guard let kidName = kidNameTF.text, kidName.trimWhiteSpaces().count > 0 else {
                     self.showAlertWithTitleInView(title: "", message:"Please enter Kid Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                     
                     return
                 }
                
        guard let kidclass = classBtnOutlet.titleLabel?.text, kidclass.trimWhiteSpaces().count > 0 else {
                     // alert for enter password
                     self.showAlertWithTitleInView(title: "", message:"Please enter Class.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                     return
                 }
        guard let schoolName = kidSchoolTF.text, schoolName.trimWhiteSpaces().count > 0 else {
            // alert for enter password
            self.showAlertWithTitleInView(title: "", message:"Please enter School Name.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            return
        }
        
        
        if kid_id == "" {
         kid_id = randomString(kidname: kidName,kidclass: kidclass,kidschool: schoolName)
        }
        
        var kidDataDic = NSMutableDictionary()
        
       
         guard let parentID = UserDefaults.standard.string(forKey: "parentId")
                    
                    else { return print("No data") }
        if self.mode == "edit" {
            mode = "edit"
        }else{
            mode = "new"

        }
        
        
        
        let payLoad = [ "mode":mode, "parentId": parentID, "className": kidclass, "school": schoolName,"studentName": kidName]

        kidDataDic = ["parentId": parentID, "kidclass": kidclass, "kidschool": schoolName,"kidName": kidName , "kid_id" : self.kid_id]

        if parentID == "null"  {
            
            self.insertKidToCoredata(kid_id: self.kid_id,dataDic: kidDataDic)
            
        }else{

            SAPIController.shared.addKidAPI(payload: payLoad) { (result, errorMessage) in
                print("Login Response---- %@ /n %@", result,errorMessage)
                
                SProgress.hide()
                
                if let error = errorMessage {
                    
                    print("signup error message---- %@ /n %@", error)
                    
                }else{
                    
                    //if self.mode == "new" {
                    self.insertKidToCoredata(kid_id: self.kid_id ,dataDic: kidDataDic)
                    //}
                    

                    self.showAlertWithTitleInView(title: "Success!", message: "Added New Kid!", buttonCancelTitle: "", buttonOkTitle: "OK"){
                        (index) in
                        
                    }
                    return
                    
                }
            }
        }
    
    }
    
    func insertKidToCoredata(kid_id: String , dataDic : NSMutableDictionary){
        
        
        self.appDelegate!.insertNewRecord(withData : dataDic , userId : kid_id , inentity : "KidsData")
        //appDelegate!.insertNewRecordofControlNumber(withValue :dataDic,  atcontrolNumber : parentID , forKey: "praposalFormAT")
     
        let results = self.appDelegate!.getAllRecordsforValue(valueof: kid_id, forattribute: "kid_Id" , forEntity : "KidsData")
               for result in results {
                   let formNameIs = result.value(forKey: "kidName") as? String
                   //identifierArray.append(formNameIs!)
                   //print(formNameIs!)
               }

    }
   
    
}
