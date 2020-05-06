//
//  SearchViewController.swift
//  Student App
//
//  Created by kalyan on 21/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SearchViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet var bookseriesTableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    var filteredLessions = [LessionName]()
    var mylessonIdArray = NSMutableArray()
    var mysubjectData = NSMutableArray()
    var favoriteBooks = [MyFavoritesData]()

    //Fetch all lession from coredata
    var allLessions = [LessionName]()

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           searchController.searchResultsUpdater = self
                 searchController.dimsBackgroundDuringPresentation = false
                 definesPresentationContext = true
                 bookseriesTableView.tableHeaderView = searchController.searchBar
                 searchController.searchBar.tintColor = UIColor.blue
                 searchController.searchBar.barTintColor = UIColor.white
        
        self.getLessonsFromCoreData()

       }
    
    
    func getLessonsFromCoreData(){
        
        self.mylessonIdArray.removeAllObjects()
        self.mysubjectData.removeAllObjects()
        self.allLessions.removeAll()
        
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        
        let results = self.appDelegate!.getAllRecordsforValue(valueof: "", forattribute: "", forEntity: "LessionDB")
        
        
        if results.count == 0 {
            self.favoriteBooks.removeAll()
        }else{
            for result in results {
                print(result.value(forKey: "id") as! String)
                let leaasionName = result.value(forKey: "lessionName") as! String
                let id = result.value(forKey: "id") as! String
                let bookid = result.value(forKey: "bookid") as! String
                let classname = result.value(forKey: "classname") as! String

                let bookname = result.value(forKey: "bookName") as! String
                let bookseries = result.value(forKey: "bookseries") as! String
                let subjectid = result.value(forKey: "subjectid") as! String
                let subjectname = result.value(forKey: "subjectname") as! String
                let lessionid = result.value(forKey: "lessionid") as? String ?? ""

                self.allLessions.append(LessionName(lessionname: leaasionName, id: id, bookid: bookid, bookseries: bookseries, subjectid: subjectid, subjectname: subjectname, classname: classname, bookname: bookname, lessionid: lessionid))

               /* let learningbookData = result.value(forKey: "learningbookData") as? NSArray
                let kid_Id = result.value(forKey: "kid_Id") as? String
                let lessionTitle = result.value(forKey: "lessionTitle") as? String
                let lessonId = result.value(forKey: "lessonId") as? String
                self.allLessions.append(LessionName(name: lessionTitle!, id: lessonId!))
                let lstudentQuestions = result.value(forKey: "lstudentQuestions") as? NSArray
                let lstudentsubject = result.value(forKey: "lstudentsubject") as? String
                let lstudentvideo = result.value(forKey: "lstudentvideo") as? NSArray
                
                self.mylessonIdArray.add(lessonId as Any)
                
                self.mysubjectData.add(lstudentsubject as! String)
                
                let datalstudentsubject = self.asString(dataString: lstudentsubject!)
                
                print("datalstudentsubject ," , datalstudentsubject)
                print("datalstudentsubject ," , learningbookData)
                
                
                self.favoriteBooks.append(MyFavoritesData(kid_Id: kid_Id!, learningbookData: learningbookData!, lessionTitle: lessionTitle!, lessonId: lessonId!, lstudentQuestions: lstudentQuestions!, lstudentsubject: datalstudentsubject as NSDictionary, lstudentvideo: lstudentvideo!))*/
                
            }
        }
        self.bookseriesTableView.reloadData()
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

    //MARK: - TableView Delegates
          
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
              if searchController.isActive && searchController.searchBar.text != "" {
                return filteredLessions.count
              }
            return self.allLessions.count
            
    }
          
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 35
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            
            
              let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)
              let footballer: LessionName
            
              if searchController.isActive && searchController.searchBar.text != "" {
                footballer = filteredLessions[indexPath.row]
              } else {
                footballer = allLessions[indexPath.row]
              }
              cell.textLabel?.text = footballer.lessionname
           
            return cell
          }
    
          
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let lessionData = allLessions[indexPath.row]

             let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivitesViewController") as! ActivitesViewController
            // let lessonData = self.favoriteBooks[indexPath.row]
            var bookdata:[String] = ["","","","","","","","",""]
            let mirror = Mirror(reflecting: lessionData)

            for child in mirror.children  {
                if child.label == "lessionname" {

                }else if child.label! == "bookseries" {
                    bookdata.insert(child.value as! String, at: 0)

                }else if child.label! == "subjectid" {
                    bookdata.insert(child.value as! String, at: 4)

                }else if child.label! == "subjectname" {
                    bookdata.insert(child.value as! String, at: 3)

                }else if child.label! == "classname" {
                    bookdata.insert(child.value as! String, at: 1)

                }else if child.label! == "bookname" {
                    bookdata.insert(child.value as! String, at: 2)

                }else if child.label! == "bookid" {
                    bookdata.insert(child.value as! String, at: 5)
                }
                print("key: \(child.label), value: \(child.value)")
            }
            
             vc.learningbookData = bookdata
            vc.lessionTitle = lessionData.lessionname
            vc.lstudentsubject = [:]
             //vc.lstudentvideo = lessonData.lstudentvideo
             //vc.lstudentQuestions = lessonData.lstudentQuestions
            vc.lessionId = lessionData.lessionid
             //send status of favourite
             vc.isFavorite = true
            vc.studentSubject = lessionData.subjectname
            self.navigationController?.pushViewController(vc, animated: true)
            

       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func filterLessions(for searchText: String) {
      filteredLessions = allLessions.filter { footballer in
        return
          footballer.lessionname.lowercased().contains(searchText.lowercased())
      }
      bookseriesTableView.reloadData()
    }

}

@available(iOS 10.0, *)
extension SearchViewController: UISearchResultsUpdating {
   func updateSearchResults(for searchController: UISearchController) {
    filterLessions(for: searchController.searchBar.text ?? "")
    }
}


struct LessionName {
  var lessionname: String
  var id: String
    var bookid: String
    var bookseries: String
    var subjectid: String
    var subjectname: String
    var classname: String
    var bookname: String
    var lessionid: String
}
