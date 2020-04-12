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
class LessionsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
  
    

    @IBOutlet weak var seriesLB: UILabel!
    @IBOutlet weak var lessonsTableView: UITableView!
    @IBOutlet weak var classLB: UILabel!
    @IBOutlet weak var bookNameLB: UILabel!
    @IBOutlet weak var subjectLb: UILabel!
    var bookData : [String] = []
    var book_id : String?
    var subject_id : String?
    var lessonDataArray = [lessonData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("books data", bookData)
        book_id = bookData[5]
        subject_id = bookData[4]
        loadLessonDetails( classToPass:  book_id!+"/"+subject_id!)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.seriesLB?.text = bookData[0]
        self.classLB?.text = bookData[1]
        self.bookNameLB?.text = bookData[2]
        self.subjectLb?.text = bookData[3]

     }
    // With Alamofire
    func loadLessonDetails( classToPass : String ) {
        SProgress.show()
        let baseURLString = APIEndPoints.base.urlString
        
        guard let url = URL(string: baseURLString+"/API/lesson/getLessonDetails/"+classToPass) else {
            //completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
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
                        let activitse = obj["studentQuestions"] as! NSArray
                        var stydentArray : NSMutableArray = []

                        
                        if let imagesArray = obj["studentvideo"] as? NSDictionary{
                            stydentArray.add(imagesArray)
                        }else{
                            
                            let nsArray = obj["studentvideo"] as! NSArray
                            stydentArray.addObjects(from: nsArray as! [Any])

                        }
                        
                        let activities = obj["studentQuestions"] as! NSArray
                        
                        let studentsubject = obj["studentsubject"] as! NSDictionary

                        self.lessonDataArray.append(lessonData(lessonName: lessonName, learnings: stydentArray.count, studentQuestionsAct: activitse.count, studentsubject: studentsubject, studentvideo: stydentArray, studentQuestions: activities))

                    }
                    self.lessonsTableView.reloadData()
                    
                    SProgress.hide()
                    print("hi hello ther")
            
                }
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
                let lessonData = self.lessonDataArray[indexPath.row]
                cell.lessaonNameLb?.text = lessonData.lessonName!
                let learning = lessonData.learnings!
                cell.learnings?.text = "Learning: \(learning)"
                let activities = lessonData.studentQuestionsAct!
                cell.activitiesLb?.text = "Learning: \(activities)"
                
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
            vc.lstudentvideo = lessonData.studentvideo
            vc.lstudentQuestions = lessonData.studentQuestions
            
            self.present(vc, animated: true, completion: nil)


           
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
