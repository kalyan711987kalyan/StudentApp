//
//  LessionsViewController.swift
//  Student App
//
//  Created by kalyan on 09/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import  Alamofire

@available(iOS 10.0, *)
class LessionsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate ,addFavouriteCellDelegate {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func didFavouritePressButton(_ tag: Int) {
        
        guard let parentID = UserDefaults.standard.string(forKey: "parentEmail")
            else { return print("No data") }
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        
        print("I have pressed a download button with a tag: \(tag)")
        
        let leesnId = self.lessonIdArray[tag] as! String
        var msg = String()
        var title = String()
        var flag = Int()
        
        if self.FavouriteslessonId.contains(leesnId) {
            flag = 0
            title = "Remove as Favourite?"
            msg = "This lesson shall be removed to my Favs!"
        }else{
            flag = 1
            title = "Add to my Favs?"
            msg = "This lesson shall be added to my Favs!"
        }
        
        
        self.showAlertWithTitleInView(title: title, message: msg, buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
            
            if index == 1{
                
                self.FavouriteslessonId.removeAllObjects()
                let lessonData = self.lessonDataArray[tag]
                //vc.learningbookData = bookData
                let lessionTitle = lessonData.lessonName!
                let lstudentsubject = lessonData.studentsubject
               // let lstudentvideo = lessonData.studentvideo
               // let lstudentQuestions = lessonData.studentQuestions
                let activites = Int(lessonData.activities) ?? 0
                 let learning = Int(lessonData.learnings) ?? 0
                let activitesArray = Array(0...activites-1)
                let learningArray = Array(0...learning-1)

                var isSuccess : Bool = true
                if flag == 1 {
                    
                    isSuccess = self.appDelegate!.addFavouriteToCoreData(withlessonData: self.bookData as NSArray, kid_id: kidId, parent_id: parentID, lessonId: self.lessonIdArray[tag] as! String, lessionTitle: lessionTitle, lstudentQuestions: activitesArray as NSArray, lstudentsubject: self.subjectData[tag] as! String , lstudentvideo: learningArray as NSArray)
                    
                }else{
                    
                    isSuccess = self.appDelegate!.deleteRecordforValue(valueof: leesnId, forattribute: "lessonId", forEntity: "Favourites")
                }
                
                if isSuccess == true {
                    
                    let  results = self.appDelegate!.getAllRecordsforValue(valueof: kidId, forattribute: "kid_Id", forEntity: "Favourites")
                    for result in results {
                        
                        let lessonId = result.value(forKey: "lessonId") as? String
                        self.FavouriteslessonId.add(lessonId!)
                        
                        self.lessonsTableView.reloadData()
                        
                    }
                    
                }else{
                    
                }
            }else{
                
            }
        }
    }
    
    @IBOutlet weak var seriesLB: UILabel!
    @IBOutlet weak var lessonsTableView: UITableView!
    @IBOutlet weak var classLB: UILabel!
    @IBOutlet weak var bookNameLB: UILabel!
    @IBOutlet weak var subjectLb: UILabel!
    var bookData : [String] = []
    var lessonIdArray = NSMutableArray()
    var book_id : String?
    var subject_id : String?
    var kid_id : String?
    var lessonDataArray = [lessonData]()
    var subjectData = NSMutableArray()
    var FavouriteslessonId = NSMutableArray()
    typealias JSONDictionary = [String : Any]
    var rowsWhichAreChecked = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("books data", bookData)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        book_id = bookData[5]
        subject_id = bookData[4]
        
        if subject_id == "" {
            subject_id = "1"
        }
        
        loadLessonDetails( classToPass:  book_id!+"/"+subject_id!)
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        kid_id = kidId
        //coredata
        FavouriteslessonId.removeAllObjects()
        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kid_id!, forattribute: "kid_Id", forEntity: "Favourites")
        for result in results {
            let lessonId = result.value(forKey: "lessonId") as? String
            self.FavouriteslessonId.add(lessonId!)
        }
        self.seriesLB?.text = bookData[0]
        self.classLB?.text = bookData[1]
        self.bookNameLB?.text = bookData[2]
        self.subjectLb?.text = bookData[3]
        
    }
    // With Alamofire
    func loadLessonDetails( classToPass : String ) {
        self.lessonIdArray.removeAllObjects()
        self.subjectData.removeAllObjects()
        self.lessonDataArray.removeAll()
        SProgress.show()
        let baseURLString = APIEndPoints.base.urlString
        
        guard let url = URL(string: baseURLString+"/API/lesson/getLessonDetails/"+classToPass) else {
            //completion(nil)
            return
        }
        print(url)
        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    SProgress.hide()
                    //print("Error while fetching remote rooms: \(String(describing: response.result.error)")
                    //completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["lessons"] as? [[String: Any]] else {
                        SProgress.hide()
                        self.showAlertWithTitleInView(title: "", message:"No Lessons availiable!", buttonCancelTitle:"", buttonOkTitle: "OK"){
                            (index)
                            in
                            self.dismiss(animated: false, completion: nil)
                        }
                        return
                }
                if let response = response.result.value as? [String:Any] {
                    
                    let booksObj = response["lessons"] as? [[String:Any]]
                    
                    for (index, obj) in booksObj!.enumerated() {
                        let lessonName = obj["lessonName"] as! String
                        let lessonId = obj["lessonId"] as! String
                        self.lessonIdArray.add(lessonId)
                        
                       // let activitse = obj["studentQuestions"] as? NSArray ?? []
                        let activitse = obj["actitvitiesCount"] as? String ?? "0"
                        let learning = obj["learningsCount"] as? String ?? "0"

                        
                        var stydentArray : NSMutableArray = []
                        
                        
                        if let imagesArray = obj["studentvideo"] as? NSDictionary{
                            stydentArray.add(imagesArray)
                        }else{
                            
                            let nsArray = obj["studentvideo"] as? NSArray ?? []
                            stydentArray.addObjects(from: nsArray as! [Any])
                            
                        }
                        
                        let activities = obj["studentQuestions"] as? NSArray ?? []
                        
                        let studentsubject = obj["studentsubject"] as? NSDictionary ?? [:]
                        
                        let dict: JSONDictionary = obj["studentsubject"] as! LessionsViewController.JSONDictionary
                        let dictAsString = self.asString(jsonDictionary: dict)
                        print("dictAsString",dictAsString)
                        self.subjectData.add(dictAsString)
                        self.lessonDataArray.append(lessonData(lessonName: lessonName,learnings: learning, studentsubject: studentsubject, lessonId: lessonId, activites: activitse))
                        
                    }
                    self.lessonsTableView.reloadData()
                    
                    SProgress.hide()
                    
                }
        }
    }
    
    func asString(jsonDictionary: JSONDictionary) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lessonDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessionsTableViewCell", for: indexPath) as! LessionsTableViewCell
        
        if self.lessonDataArray.count > 0 {
            cell.cellDelegate = self
            cell.favBtn?.tag = indexPath.row
            let lessonData = self.lessonDataArray[indexPath.row]
            cell.lessaonNameLb?.text = lessonData.lessonName!
            let learning = lessonData.learnings!
            cell.learnings?.text = "Learning: \(learning)"
            let activities = lessonData.activities
            cell.activitiesLb?.text = "Activities: \(activities)"
            
            let lessonId = lessonData.lessonId
            
            //let id = self.FavouriteslessonId[indexPath.row] as! String
            
            if self.FavouriteslessonId.contains(lessonId) {
                //do something
                let checkedImage = UIImage(named: "favicon.png")! as UIImage
                
                cell.favBtn!.setImage(checkedImage, for: .normal)
                
            }else{
                let uncheckedImage = UIImage(named: "love.png")! as UIImage
                
                cell.favBtn!.setImage(uncheckedImage, for: .normal)
                
            }
            
            
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivitesViewController") as! ActivitesViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        
        let lessonData = self.lessonDataArray[indexPath.row]
        vc.learningbookData = bookData
        vc.lessionTitle = lessonData.lessonName!
        vc.lstudentsubject = lessonData.studentsubject
       // vc.lstudentvideo = lessonData.studentvideo
        //vc.lstudentQuestions = lessonData.studentQuestions
        vc.lessionId = self.lessonIdArray[indexPath.row] as! String
        //send status of favourite
        let leesnId = self.lessonIdArray[indexPath.row] as! String
        var isFavourite : Bool = true
              
              if self.FavouriteslessonId.contains(leesnId) {
                 isFavourite = true
              }else{
                  isFavourite = false
              }
        vc.isFavorite = isFavourite
        vc.studentSubject = self.subjectData[indexPath.row] as! String
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    @IBAction func backBtn(_ sender: Any) {
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
    
}
