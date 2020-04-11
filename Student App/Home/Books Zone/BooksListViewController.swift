//
//  BooksListViewController.swift
//  Student App
//
//  Created by kalyan on 29/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import Alamofire

@available(iOS 10.0, *)
class BooksListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , YourCellDelegate{
    
    var seriesNameText :String = ""
    var className : String = ""
    var image = UIImage()
    var classToPass : String = ""
    var kid_id : String = ""
    var parent_id : String = ""
    var selectedKid: KidObject?
    @IBOutlet weak var seriesName: UILabel!
    @IBOutlet weak var classNameLB: UILabel!
    @IBOutlet weak var bookslistTableview: UITableView!
    var downloadBookArray = [downloadBook]()
    var jsonObjectArray = NSMutableArray()
    var bookIdArray = NSMutableArray()
    typealias JSONDictionary = [String : Any]
    let appDelegate = UIApplication.shared.delegate as? AppDelegate


    
    @IBOutlet weak var floatingImageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatingImageView.isHidden = true
        //get active kid and parent id
        guard let parentID = UserDefaults.standard.string(forKey: "parentEmail")
            else { return print("No data") }
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        kid_id = kidId
        parent_id = parentID
        if className == "Nursery" {
            classToPass = "1"
        }else if className == "LKG" {
            classToPass = "2"
        } else if className == "UKG" {
            classToPass = "3"
        }else if className == "I" {
            classToPass = "4"
        } else if className == "II" {
            classToPass = "5"
        }else if className == "III" {
            classToPass = "6"
        } else if className == "IV" {
            classToPass = "7"
        }else if className == "V" {
            classToPass = "8"
        } else if className == "VI" {
            classToPass = "9"
        }else if className == "VII" {
            classToPass = "10"
        }else if className == "VIII"{
            classToPass = "11"
        }else if className == "IX" {
            classToPass = "12"
        }else if className == "X"{
            classToPass = "13"
        }
        
        // Do any additional setup after loading the view.
        fetchAllRooms(classToPass : classToPass)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.classNameLB.text = className
        
    }
    
    @IBAction func closeImageBTN(_ sender: Any) {
        self.floatingImageView.isHidden = true
        
    }
    // With Alamofire
    func fetchAllRooms( classToPass : String ) {
        SProgress.show()
        let baseURLString = APIEndPoints.base.urlString
        
        guard let url = URL(string: baseURLString+"/API/book/getBookDetails/"+classToPass) else {
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
                    let rows = value["book"] as? [[String: Any]] else {
                        SProgress.hide()
                        self.showAlertWithTitleInView(title: "", message:"No Books Available!", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                        return
                       
                }
                if let response = response.result.value as? [String:Any] {
                    SProgress.hide()
                    
                    let booksObj = response["book"] as? [[String:Any]]
                    
                    for (index, obj) in booksObj!.enumerated() {
                        print("index",index)
                        let dict: JSONDictionary = obj
                        let dictAsString = self.asString(jsonDictionary: dict)
                        print("dictAsString",dictAsString)
                        self.jsonObjectArray.add(dictAsString)
                        
                        let bookName = obj["bookName"] as! String
                        let description = obj["description"] as! String
                        let thumbnail = obj["thumbnail"] as! String
                        let studentseries = obj["studentseries"] as! [String : Any]
                        let series = studentseries["series"] as! String
                        let studentbooktype = obj["studentbooktype"] as! [String : Any]
                        let bookType = studentbooktype["bookType"] as! String
                        let bookId = obj["bookId"] as! String

                        
                        self.bookIdArray.add(bookId)
                        
                        if series == self.seriesNameText {
                            self.downloadBookArray.append(downloadBook(bookName: bookName, bookType: bookType, description: description, thumbnail: thumbnail, bookseries: series))
                        }
                        print("downloadBookArray",self.downloadBookArray)
                        print("downloadBookArray",self.downloadBookArray[0].bookName as Any)
                    }
                    self.bookslistTableview.reloadData()
                    
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downloadBookArray.count //customerList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksListTableViewCell", for: indexPath) as! BooksListTableViewCell
        
        if self.downloadBookArray.count > 0 {
            cell.cellDelegate = self
            cell.imageBTN?.tag = indexPath.row
            cell.downloadBtnAction?.tag = indexPath.row
            let bookData = self.downloadBookArray[indexPath.row]
            let thumbnailURl = bookData.thumbnail!
            let bookname = bookData.bookName!
            let booktype = bookData.bookType!
            let description = bookData.description!
            cell.bookNameLB?.text = bookname
            cell.bookTypeLB?.text = booktype
            cell.descriptionLB?.text = description
            
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
    
    func showImageOnselection(thumbnailURlIS : String){
        
        let url : NSString = thumbnailURlIS as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        let data = try? Data(contentsOf: searchURL as URL)
        
        //self.floatingImageView.image = // Error here
        
        let imageView = UIImageView(image: UIImage(data: data!))
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
        imageView.center = self.floatingImageView.center
        self.floatingImageView.addSubview(imageView)
        //Imageview on Top of View
        self.floatingImageView.bringSubviewToFront(imageView)
        SProgress.hide()
        
    }
    
    func didPressButton(_ tag: Int) {
        self.floatingImageView.isHidden = false
        SProgress.show()
        print("I have pressed a button with a tag: \(tag)")
        let bookData = self.downloadBookArray[tag]
        let thumbnailURl = bookData.thumbnail!
        self.showImageOnselection(thumbnailURlIS: thumbnailURl)
    }
    
    func asString(jsonDictionary: JSONDictionary) -> String {
      do {
        let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
      } catch {
        return ""
      }
    }
    
    func didPressDownloadButton(_ tag: Int) {
        print("I have pressed a download button with a tag: \(tag)")
        self.showAlertWithTitleInView(title: "Download Book?", message:"Let's download the Book to My Books!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
            print (index);
            
            if index == 1{
                
                SProgress.show()
                let isSuccess = self.appDelegate!.downloadBookToCoreData(withbookData: self.jsonObjectArray[tag] as! String , kid_id : self.kid_id ,parent_id : self.parent_id , book_id: self.bookIdArray[tag] as! String)
                
                if isSuccess == true {
                    SProgress.hide()
                    self.showAlertWithTitleInView(title: "Success!", message:"Do you want to open the downloaded Book?", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                        if index == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadedBooksViewController") as! DownloadedBooksViewController
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    
                    
                }else{
                    SProgress.hide()
                    self.showAlertWithTitleInView(title: "Failed!", message:"Failed to Download Book!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in}
                }
            }else{
                
            }
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
        
}
