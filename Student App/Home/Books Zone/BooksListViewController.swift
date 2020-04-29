//
//  BooksListViewController.swift
//  Student App
//
//  Created by kalyan on 29/03/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

@available(iOS 10.0, *)
class BooksListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , YourCellDelegate{
    var bombSoundEffect: AVAudioPlayer?
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
    var downloadedBookidArray = NSMutableArray()


    
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
        getListOfBooksDownloaded()
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
            SProgress.hide()
            return
        }
        print("url",url)

        Alamofire.request(url,
                          method: .get,
                          parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    self.showAlertWithTitleInView(title: "", message:"Request failed. Please try again", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                    SProgress.hide()
                    return
                }
                print("Response",response.result)

                
                SProgress.hide()
                if let response = response.result.value as? [String:Any],  let booksObj = response["book"] as? [[String:Any]] {
                    
                    for (index, obj) in booksObj.enumerated() {
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
                        let bookTypeIdId = obj["booktypeId"] as! String

                        
                        self.bookIdArray.add(bookId)
                        
                        if series == self.seriesNameText {
                            self.downloadBookArray.append(downloadBook(bookName: bookName, bookType: bookType, description: description, thumbnail: thumbnail, bookseries: series , bookTypeId : bookTypeIdId  ))
                        }
                        print("downloadBookArray",self.downloadBookArray)
                        print("downloadBookArray",self.downloadBookArray[0].bookName as Any)
                    }
                    self.bookslistTableview.reloadData()
                    
                }else {
                    
                    guard let value = response.result.value as? [String: Any],
                        let obj = value["book"] as? [String: Any] else {
                            SProgress.hide()
                            self.showAlertWithTitleInView(title: "", message:"No Books Available!", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                            return
                           
                    }
                    
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
                    let booktypeId = obj["booktypeId"] as! String

                                        
                                        self.bookIdArray.add(bookId)
                                        
                                        
                    if series == self.seriesNameText {
                        self.downloadBookArray.append(downloadBook(bookName: bookName, bookType: bookType, description: description, thumbnail: thumbnail, bookseries: series, bookTypeId: booktypeId))
                                        }
                    self.bookslistTableview.reloadData()

                }
                
        }
    }
    
    func getListOfBooksDownloaded(){
        downloadedBookidArray.removeAllObjects()
        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kid_id, forattribute: "kid_Id", forEntity: "DownloadedBooks")
        
        if results.count > 0{
       for result in results {
        let bookId = result.value(forKey: "book_id") as? String
        self.downloadedBookidArray.add(bookId as Any)
            }
        }
        self.bookslistTableview.reloadData()

    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downloadBookArray.count //customerList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksListTableViewCell", for: indexPath) as! BooksListTableViewCell
        cell.selectionStyle = .none
        cell.thumbnailImageView?.image = nil

        if self.downloadBookArray.count > 0 {
            cell.cellDelegate = self
            cell.imageBTN?.tag = indexPath.row
            cell.downloadBtnAction?.tag = indexPath.row
            
            let bookData = self.downloadBookArray[indexPath.row]
            let downloadeBookId = self.bookIdArray[indexPath.row]
            if self.downloadedBookidArray.contains(downloadeBookId) {
                         //do something
                cell.downloadBtnAction?.isHidden = true
            }else{
                cell.downloadBtnAction?.isHidden = false
            }

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
           // let data = try? Data(contentsOf: searchURL as URL)
            
           // cell.thumbnailImageView?.image = UIImage(data: data!)// Error here
            
            cell.thumbnailImageView?.load(url: searchURL as URL)
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func showImageOnselection(thumbnailURlIS : String, image: UIImage?){
        
    
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
            imageView.center = self.floatingImageView.center
            self.floatingImageView.addSubview(imageView)
            self.floatingImageView.bringSubviewToFront(imageView)
        }else{
            
                    let url : NSString = thumbnailURlIS as NSString
                    let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    let searchURL : NSURL = NSURL(string: urlStr as String)!
                    let data = try? Data(contentsOf: searchURL as URL)
            let imageView = UIImageView(image: UIImage(data: data!))
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
            imageView.center = self.floatingImageView.center
            self.floatingImageView.addSubview(imageView)
            //Imageview on Top of View
            self.floatingImageView.bringSubviewToFront(imageView)
        }

        
        //self.floatingImageView.image = // Error here
        
        
        
    }
    
    func didPressButton(_ tag: Int, image: UIImage?) {
        self.floatingImageView.isHidden = false
        print("I have pressed a button with a tag: \(tag)")
        let bookData = self.downloadBookArray[tag]
        let thumbnailURl = bookData.thumbnail!
        self.showImageOnselection(thumbnailURlIS: thumbnailURl, image: image)
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
                
                let bookData = self.downloadBookArray[tag]
                let bookTypeId = bookData.bookTypeId
                SProgress.show(in: self.view, message: "Downloading...")

                print(self.jsonObjectArray[tag])
                //self.appDelegate!.downloadBookToCoreData(withbookData: self.jsonObjectArray[tag] as! String , kid_id : self.kid_id ,parent_id : self.parent_id , book_id: self.bookIdArray[tag] as! String, booktypeId: bookTypeId!, completion: (Bool) -> Void)
                self.appDelegate!.downloadBookToCoreData(withbookData: self.jsonObjectArray[tag] as! String, kid_id: self.kid_id, parent_id: self.parent_id, book_id: self.bookIdArray[tag] as! String, booktypeId: bookTypeId!) { (isSuccess) in
                    
                    DispatchQueue.main.async {
                        SProgress.hide(in: self.view)
                    }
                                   
                    if isSuccess == true {

                                       let path = Bundle.main.path(forResource: "deleted.wav", ofType:nil)!
                                                     let url = URL(fileURLWithPath: path)

                                                     do {
                                                       self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                                                       self.bombSoundEffect?.play()
                                                     } catch {
                                                         // couldn't load file :(
                                                     }
                                       self.showAlertWithTitleInView(title: "Success!", message:"Do you want to open the downloaded Book?", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                                           if index == 1 {
                                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadedBooksViewController") as! DownloadedBooksViewController
                                   vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                vc.highlightBookId = self.bookIdArray[tag] as! String
                               self.present(vc, animated: true, completion: nil)
                                           }
                                       }
                                       self.getListOfBooksDownloaded()

                                       
                                   }else{
                                       self.showAlertWithTitleInView(title: "Failed!", message:"Failed to Download Book!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in}
                                   }
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

