//
//  DownloadedBooksViewController.swift
//  Student App
//
//  Created by kalyan on 08/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//


import UIKit
import Alamofire

@available(iOS 10.0, *)

class DownloadedBooksViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , downloadedCellDelegate, UITabBarControllerDelegate{
    
    @IBAction func clearAllBoks(_ sender: Any) {
        
        self.showAlertWithTitleInView(title: "Clear-Off All Books?", message:"This shall Clear-Off All Books from the App!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                   if index == 1{
                       
                    let result = self.appDelegate!.deleteRecordforValue(valueof: self.kid_id , forattribute: "kid_Id", forEntity: "DownloadedBooks")
                       if result == true {
                           self.getDataFromeCoreData(kid_id: self.kid_id)
                       }
                    
                    _ = self.appDelegate!.deleteAllDataOfEntity(forEntity: "LessionDB")

                       
                   }
            
           

               }
        
    }
    
    func didDeletePressButton(_ tag: Int) {
        
        self.showAlertWithTitleInView(title: "Delete this Book?", message:"You want to Remove this Book from App!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
            if index == 1{
                
                let result = self.appDelegate!.deleteRecordforValue(valueof: self.BookidArray[tag] as! String, forattribute: "book_id", forEntity: "DownloadedBooks")
                if result == true {
                    _ = self.appDelegate!.deleteAllRecordsOfKid(valueof: self.BookidArray[tag] as! String, forattribute: "bookid", forEntity: "LessionDB")

                    self.getDataFromeCoreData(kid_id: self.kid_id)
                }
                
            }
        }


    }
    
    func didshowImagePressButton(_ tag: Int, image: UIImage?) {
       // self.showFloatingView.isHidden = false
        //SProgress.show()
        print("I have pressed a button with a tag: \(tag)")
        let bookData = self.downloadedBooks[tag]
        let thumbnailURl = bookData.thumbnail!
        self.showdownloadedOnselection(thumbnailURlIS: thumbnailURl, image: image)

    }
    func showdownloadedOnselection(thumbnailURlIS : String, image: UIImage?){
           
        if let modalViewController = self.storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController {

                   modalViewController.view.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
                          modalViewController.modalPresentationStyle = .overCurrentContext
                   modalViewController.imageview.image = image
                          present(modalViewController, animated: true, completion: nil)
                                

               }
          /* let url : NSString = thumbnailURlIS as NSString
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
           SProgress.hide()*/
       }

    @IBOutlet weak var downloadedBooksTableview: UITableView?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var jsonBooksArray = NSMutableArray()
    var BookidArray = NSMutableArray()
    var BookTypeidArray = NSMutableArray()

    var responseObject = [[String : Any]]()
    var downloadedBooks = [downloadedBook]()
    var kid_id = String()
    var didTappedAtBook = NSInteger()
    var highlightBookId:String?
    @IBOutlet weak var allBooksBTNOutlet: UIButton?
    @IBOutlet weak var showFloatingView: UIView?
    @IBOutlet var popupView: UIView?
    @IBOutlet var popViewHeightConstraints: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        self.showFloatingView?.isHidden = true
        self.popupView?.isHidden = true

        SProgress.show()

              guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
                                          else { return print("No data") }
                                      kid_id = kidId
                           getDataFromeCoreData(kid_id: kidId)

    }
    override func viewWillAppear(_ animated: Bool) {
       

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.showFloatingView?.isHidden = true
        self.popupView?.isHidden = true

    }

    @IBAction func backButton_Action() {
        
        self.tabBarController?.selectedIndex = 0
    }
    
    func reloadViews() {
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
                                                 else { return print("No data") }
                                             kid_id = kidId
                                  getDataFromeCoreData(kid_id: kidId)
    }
    
    func getDataFromeCoreData(kid_id : String){

        self.downloadedBooks.removeAll()
        self.jsonBooksArray.removeAllObjects()
        self.responseObject.removeAll()
        self.BookidArray.removeAllObjects()
        self.BookTypeidArray.removeAllObjects()

        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kid_id, forattribute: "kid_Id", forEntity: "DownloadedBooks")
        
        if results.count == 0{
            allBooksBTNOutlet?.isHidden = true
            SProgress.hide()

             self.showAlertWithTitleInView(title: "", message:"No My Books!. Please download from BookZone  ", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index)
                in
                self.dismiss(animated: true, completion: nil)

            }
            
            
        }else{
            allBooksBTNOutlet?.isHidden = false

        for result in results {
            
                   let kid_id = result.value(forKey: "kid_Id") as? String
                   let parent_id = result.value(forKey: "parent_Id") as? String
                   let booksData = result.value(forKey: "bookData") as? String
            
            let bookId = result.value(forKey: "book_id") as? String
            let bookTypeId = result.value(forKey: "bookTypeId") as? String

            self.BookTypeidArray.add(bookTypeId)
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
                let bookid = obj["bookId"] as! String

                //let subjectsObjs = obj["subjects"] subjectId
                let subjectArray : NSMutableArray = []
                
                if let earthquakes = obj["subjects"] as? [[String:Any]] {
                    for earthquake in earthquakes {
                        let lat = earthquake["studentsubject"] as! [String : Any]
                        let subjectId = earthquake["subjectId"] as! String

                        let subject = lat["subjectName"]!
                        // get other values
                        print(lat, subject)
                        let details = [subject , subjectId];
                        subjectArray.add(details)
                    }
                }
                print("subjects", subjectArray)
                print("book Data", obj["bookId"])

                self.downloadedBooks.append(downloadedBook(bookName: bookName, bookType: bookType, description: description, thumbnail: thumbnail, bookseries: series, className: className, subjects: subjectArray, bookid: bookid ))
                       }
            SProgress.hide()
        }
        self.downloadedBooksTableview?.reloadData()

    }
    
    @IBAction func hideImageView(_ sender: Any) {
        self.showFloatingView?.isHidden = true

    }
    @IBAction func hidepopView(_ sender: Any) {
        self.popupView?.isHidden = true

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
       
        cell.thumbnailImageView?.image = nil
        if self.downloadedBooks.count > 0 {
                  cell.cellDelegate = self
                  cell.deleteBookbtn?.tag = indexPath.row
            cell.showImageBtn?.tag = indexPath.row
                  let bookData = self.downloadedBooks[indexPath.row]
            print(self.highlightBookId)
            if let bookid = self.highlightBookId, bookid == bookData.bookId {
                cell.cellView?.backgroundColor = .lightGray
            }else{
                cell.cellView?.backgroundColor = .white

            }

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
            cell.thumbnailImageView?.load(url: searchURL as URL)
//            DispatchQueue.main.async {
//                  let data = try? Data(contentsOf: searchURL as URL)
//                  cell.thumbnailImageView?.image = UIImage(data: data!)// Error here
//            }
                  
              }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.BookTypeidArray[indexPath.row] as? String == "1" {
            self.showFloatingView?.isHidden = true

                    //print("You have chosen Villain: \(sender.titleLabel?.text)")
            let bookData = self.downloadedBooks[indexPath.row]
            let bookId = BookidArray[indexPath.row]
            
            let subjects = bookData.subjects
            
            //let subjectsname = bookData.subjects[indexPath.row] as! NSArray
            print("You have chosen subjectsname: \(bookData)")
            
            let datatobepassed = [bookData.bookName!,bookData.bookseries!,bookData.className!,"","" , bookId]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessionsViewController") as! LessionsViewController
                          vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            vc.bookData = datatobepassed as! [String]

            self.navigationController?.pushViewController(vc, animated: false)

            
              
        }else{
            self.popupView?.isHidden = false
        didTappedAtBook = indexPath.row
        let bookData = self.downloadedBooks[indexPath.row]
        let subjects = bookData.subjects
        let bookId = BookidArray[indexPath.row]
        self.getSubjectsDetails(bookid: bookId as! String)
            
     /*       var buttonsize = self.popupView?.frame.height
        var totalHeight =  ((subjects?.count ?? 0)/2) * 75
        var buttonY: CGFloat = 50  // our Starting Offset, could be 0
        var buttonX: CGFloat = 20  // our Starting Offset, could be 0
        let colorsArray = [UIColor.orange, UIColor.brown, UIColor.blue, UIColor(red: 234.0/255.0, green: 85.0/255.0, blue: 80.0/255.0, alpha: 1.0), UIColor(red: 193.0/255.0, green: 16.0/255.0, blue: 29.0/255.0, alpha: 1.0)]
        for (index, villain) in (subjects as! [NSArray]).enumerated() {
            
            let villainButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: 80, height: 80))
            buttonX = buttonX + villainButton.frame.size.width + 20

            if ((index+1)%3 == 0  ||  buttonX > self.popupView?.frame.width ?? 300.0 ){
                buttonY = buttonY + villainButton.frame.size.height + 30
                buttonX = 20
            }
            print(buttonX, buttonY, (index+1)%3)
             
            villainButton.layer.cornerRadius = 5  // get some fancy pantsy rounding
            if let winner = colorsArray.randomElement() {
                villainButton.backgroundColor = winner
            }
           let subject = villain[0]
            villainButton.setTitle("\(subject)", for: UIControl.State.normal) // We are going to use the item name as the Button Title here.
            villainButton.titleLabel?.textAlignment = .center
            villainButton.titleLabel?.text = "\(villain)"
            villainButton.addTarget(self, action: #selector(buttonAction) , for: .touchUpInside)
            villainButton.titleLabel?.lineBreakMode = .byWordWrapping
            villainButton.titleLabel?.numberOfLines = 2
            villainButton.titleLabel?.adjustsFontSizeToFitWidth = true
            villainButton.tag = index
            self.popupView?.addSubview(villainButton)
            }
        if (Int(buttonY + 75) > totalHeight) {
            popViewHeightConstraints?.constant = buttonY + 80 + 30
        }else{
            popViewHeightConstraints?.constant = buttonY
            }*/

        }
    }
    
    func showPopupView(data: [[String:Any]]) {
        
        var buttonsize = self.popupView?.frame.height
        var totalHeight =  ((data.count ?? 0)/2) * 75
               var buttonY: CGFloat = 50  // our Starting Offset, could be 0
               var buttonX: CGFloat = 20  // our Starting Offset, could be 0
               let colorsArray = [UIColor.orange, UIColor.brown, UIColor.blue, UIColor(red: 234.0/255.0, green: 85.0/255.0, blue: 80.0/255.0, alpha: 1.0), UIColor(red: 193.0/255.0, green: 16.0/255.0, blue: 29.0/255.0, alpha: 1.0)]
        for (index, villain) in (data ).enumerated() {
                   
                   let villainButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: 80, height: 80))
                   buttonX = buttonX + villainButton.frame.size.width + 20

                   if ((index+1)%3 == 0  ||  buttonX > self.popupView?.frame.width ?? 300.0 ){
                       buttonY = buttonY + villainButton.frame.size.height + 30
                       buttonX = 20
                   }
                   print(buttonX, buttonY, (index+1)%3)
                    
                   villainButton.layer.cornerRadius = 5  // get some fancy pantsy rounding
                   if let winner = colorsArray.randomElement() {
                       villainButton.backgroundColor = winner
                   }
                   //let subjectObj = villain[index] as? [String:Any]
            let studentsubject = villain["studentsubject"] as? [String:Any]

            let subject = studentsubject?["subjectName"] as! String
                   villainButton.setTitle("\(subject)", for: UIControl.State.normal) // We are going to use the item name as the Button Title here.
                   villainButton.titleLabel?.textAlignment = .center
                   villainButton.titleLabel?.text = "\(villain)"
                   villainButton.addTarget(self, action: #selector(buttonAction) , for: .touchUpInside)
                   villainButton.titleLabel?.lineBreakMode = .byWordWrapping
                   villainButton.titleLabel?.numberOfLines = 2
                   villainButton.titleLabel?.adjustsFontSizeToFitWidth = true
                   villainButton.tag = index
                   self.popupView?.addSubview(villainButton)
                   }
               if (Int(buttonY + 75) > totalHeight) {
                   popViewHeightConstraints?.constant = buttonY + 80 + 30
               }else{
                   popViewHeightConstraints?.constant = buttonY
                   }
    }
    var subjectArray:[[String:Any]] = []
    func getSubjectsDetails(bookid: String) {
       
        SProgress.show()
        let baseURLString = APIEndPoints.base.urlString
        
        guard let url = URL(string: baseURLString+"/API/subject/getSubjectDetails/"+bookid) else {
            //completion(nil)
            return
        }
        print(url)
        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
             SProgress.hide()
            // print(response.result.value)
               
                if let response = response.result.value as? [String:Any], let subjectsarray = response["subjects"] as? [[String:Any]] {
                    self.subjectArray = subjectsarray
                    print(self.subjectArray)
                    self.showPopupView(data: self.subjectArray)
                }
        }
        
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.showFloatingView?.isHidden = true

      if sender.titleLabel?.text != nil {
                //print("You have chosen Villain: \(sender.titleLabel?.text)")
        let bookData = self.downloadedBooks[didTappedAtBook]
        let bookId = BookidArray[didTappedAtBook]
        let subjectObj = subjectArray[sender!.tag]
        print("You have chosen subjectsname: \(subjectObj)")

        let studentsubject = subjectObj["studentsubject"] as? [String:Any]

                   
        let subjectname = studentsubject?["subjectName"] as! String
        print(subjectname)
        let datatobepassed = [bookData.bookName!,bookData.bookseries!,bookData.className!,subjectname ,subjectObj["subjectId"] as? String ?? "", bookId]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessionsViewController") as! LessionsViewController
                     
        //vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.bookData = datatobepassed as! [String]
        self.navigationController?.pushViewController(vc, animated: false)
        
                  //self.present(vc, animated: true, completion: nil)
        
        
            } else {
                print("Nowhere to go :/")
            }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           let tabindex = tabBarController.selectedIndex
           if tabindex == 3 {
               self.navigationController?.popViewController(animated: false)
           }
       }

}
