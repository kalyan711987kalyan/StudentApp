//
//  DownloadedBooksViewController.swift
//  Student App
//
//  Created by kalyan on 08/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//


import UIKit
@available(iOS 10.0, *)
class DownloadedBooksViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , downloadedCellDelegate{
    @IBAction func clearAllBoks(_ sender: Any) {
        self.showAlertWithTitleInView(title: "Clear-Off All Books?", message:"This shall Clear-Off All Books from the App!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                   if index == 1{
                       
                    let result = self.appDelegate!.deleteRecordforValue(valueof: self.kid_id , forattribute: "kid_Id", forEntity: "DownloadedBooks")
                       if result == true {
                           self.getDataFromeCoreData(kid_id: self.kid_id)
                       }
                       
                   }
               }
    }
    
    func didDeletePressButton(_ tag: Int) {
        
        self.showAlertWithTitleInView(title: "Delete this Book?", message:"You want to Remove this Book from App!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
            if index == 1{
                
                let result = self.appDelegate!.deleteRecordforValue(valueof: self.BookidArray[tag] as! String, forattribute: "book_id", forEntity: "DownloadedBooks")
                if result == true {
                    self.getDataFromeCoreData(kid_id: self.kid_id)
                }
                
            }
        }


    }
    
    func didshowImagePressButton(_ tag: Int) {
        self.showFloatingView.isHidden = false
        SProgress.show()
        print("I have pressed a button with a tag: \(tag)")
        let bookData = self.downloadedBooks[tag]
        let thumbnailURl = bookData.thumbnail!
        self.showdownloadedOnselection(thumbnailURlIS: thumbnailURl)

    }
    func showdownloadedOnselection(thumbnailURlIS : String){
           
           let url : NSString = thumbnailURlIS as NSString
           let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
           let searchURL : NSURL = NSURL(string: urlStr as String)!
           let data = try? Data(contentsOf: searchURL as URL)
           
           //self.floatingImageView.image = // Error here
           
           let imageView = UIImageView(image: UIImage(data: data!))
           imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
           imageView.center = self.showFloatingView.center
           self.showFloatingView.addSubview(imageView)
           //Imageview on Top of View
           self.showFloatingView.bringSubviewToFront(imageView)
           SProgress.hide()
       }

    @IBOutlet weak var downloadedBooksTableview: UITableView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var jsonBooksArray = NSMutableArray()
    var BookidArray = NSMutableArray()
    var responseObject = [[String : Any]]()
    var downloadedBooks = [downloadedBook]()
    var kid_id = String()

    @IBOutlet weak var allBooksBTNOutlet: UIButton!
    @IBOutlet weak var showFloatingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showFloatingView.isHidden = true
        // Do any additional setup after loading the view.
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        kid_id = kidId
        getDataFromeCoreData(kid_id: kidId)
    }
    func getDataFromeCoreData(kid_id : String){
        SProgress.show()
        self.downloadedBooks.removeAll()
        self.jsonBooksArray.removeAllObjects()
        self.responseObject.removeAll()
        self.BookidArray.removeAllObjects()

        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kid_id, forattribute: "kid_Id", forEntity: "DownloadedBooks")
        
        if results.count == 0{
            allBooksBTNOutlet.isHidden = true
            SProgress.hide()

             self.showAlertWithTitleInView(title: "", message:"No Books !", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
            
        }else{
        allBooksBTNOutlet.isHidden = false

        for result in results {
            
                   let kid_id = result.value(forKey: "kid_Id") as? String
                   let parent_id = result.value(forKey: "parent_Id") as? String
                   let booksData = result.value(forKey: "bookData") as? String
            let bookId = result.value(forKey: "book_id") as? String
                 self.BookidArray.add(bookId)
                self.jsonBooksArray.add(booksData)
                  let data = self.asString(dataString: booksData!)
            print("data", data)
            self.responseObject.append(data)
               //print(formNameIs!)
               }
            
            print("responseObject",responseObject)
            
            for  obj in self.responseObject {
                let bookName = obj["bookName"] as! String
                let description = obj["description"] as! String
                let thumbnail = obj["thumbnail"] as! String
                let studentseries = obj["studentseries"] as! [String : Any]
                let studentClass = obj["studentclass"] as! [String : Any]
                let className = studentClass["className"] as! String
                let series = studentseries["series"] as! String
                let studentbooktype = obj["studentbooktype"] as! [String : Any]
                let bookType = studentbooktype["bookType"] as! String
                //let subjectsObjs = obj["subjects"]
                var subjectArray : NSMutableArray = []
                
                if let earthquakes = obj["subjects"] as? [[String:Any]] {
                    for earthquake in earthquakes {
                        let lat = earthquake["studentsubject"] as! [String : Any]
                        let subject = lat["subjectName"]!
                        // get other values
                        print(lat, subject)
                        subjectArray.add(subject)
                    }
                }
//                else{
//                    let subjects = obj["subjects"] as! [String : Any]
//                    let studentsubject = subjects["studentsubject"] as! [String : Any]
//                    let finalsubject = studentsubject["subjectName"] as! String
//                    subjectArray.add(finalsubject)
//                }
//                for subjectsObj in subjectsObjs {
//                    let student = subjectsObj["studentsubject"] as! [String : Any]
//                    let subject = student["subjectName"] as! String
//                    subjectArray.add(subject)
//                }

                print("subjects", subjectArray)
                
                self.downloadedBooks.append(downloadedBook(bookName: bookName, bookType: bookType, description: description, thumbnail: thumbnail, bookseries: series, className: className, subjects: subjectArray))
                       }
            SProgress.hide()
        }
        self.downloadedBooksTableview.reloadData()

    }
    
    @IBAction func hideImageView(_ sender: Any) {
        self.showFloatingView.isHidden = true

    }
    func asString(dataString : String) -> [String : Any] {
       let data = dataString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String : Any]
            {
               print(jsonArray) // use the json here
                print("Book 2" , jsonArray);
                return jsonArray
     
            } else {
                print("bad json")
                return ["error" : "bad Request"]
            }
        } catch let error as NSError {
            print(error)
            return ["error" : error]

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downloadedBooks.count//customerList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadedBookTableViewCell", for: indexPath) as! DownloadedBookTableViewCell
        
        if self.downloadedBooks.count > 0 {
                  cell.cellDelegate = self
                  cell.deleteBookbtn?.tag = indexPath.row
            cell.showImageBtn?.tag = indexPath.row
                  let bookData = self.downloadedBooks[indexPath.row]
                  let thumbnailURl = bookData.thumbnail!
                  let bookname = bookData.bookName!
                  let booktype = bookData.bookType!
                  let description = bookData.description!
                  cell.bookNameLB?.text = bookname
                  cell.bookTypeLB?.text = booktype
                   cell.desLB?.text = description
            cell.seriesLB?.text = bookData.bookseries!
            cell.classLB?.text = "Class: \(bookData.className!)"
                  let url : NSString = thumbnailURl as NSString
                  let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                  let searchURL : NSURL = NSURL(string: urlStr as String)!
                  let data = try? Data(contentsOf: searchURL as URL)
                  cell.thumbnailImageView?.image = UIImage(data: data!)// Error here
                  
              }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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