//
//  FavouritesViewController.swift
//  Student App
//
//  Created by kalyan on 16/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class FavouritesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  , delFavCellDelegate{
    func diddeleteFromFavButton(_ tag: Int) {
        
        
        self.showAlertWithTitleInView(title: "My Favs", message: "Do you want to delete this !", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                  
                  if index == 1{
                      let favBook = self.favoriteBooks[tag]

                    let succeess = self.appDelegate!.deleteRecordforValue(valueof: favBook.lessonId!, forattribute: "lessonId", forEntity: "Favourites")

                      if succeess == true {
                        self.getFavouritesFromCoreData()
                      }

            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteBooks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
           
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "FavourtesTableViewCell", for: indexPath) as! FavourtesTableViewCell
        
        if self.favoriteBooks.count > 0 {
            
            let favBook = self.favoriteBooks[indexPath.row]

            cell.lessonName?.text = favBook.lessionTitle
            cell.learningsLB?.text = "Learning : \(favBook.lstudentvideo.count)"
            let activities = favBook.lstudentQuestions
            cell.activityLB?.text = "Activities : \(activities.count)"

        }
        
               return cell
    }
    
    @IBAction func backBtn(_ sender: Any) {
    }
    @IBAction func videosBTN(_ sender: Any) {
    }
    
    @IBAction func deleteOptionBtn(_ sender: Any) {
        
        self.showAlertWithTitleInView(title: "My Favs!", message: "Do you want to delete all Favourite books?", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                  
            guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
                else { return print("No data") }

                  if index == 1{

                    let succeess = self.appDelegate!.deleteAllRecordsOfKid(valueof: kidId, forattribute: "kid_Id", forEntity: "Favourites")

                      if succeess == true {
                        self.getFavouritesFromCoreData()
                      }

            }
            
        }
        
    }
    @IBAction func lessonBtn(_ sender: Any) {
    }
    @IBOutlet weak var lessonsView: UIView!
    @IBOutlet weak var favouritesTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var favoriteBooks = [MyFavoritesData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getFavouritesFromCoreData()
    }
    
    func getFavouritesFromCoreData(){
        
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }

        
        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kidId, forattribute: "kid_Id", forEntity: "Favourites")
                         for result in results {
                             
                             let learningbookData = result.value(forKey: "learningbookData") as? NSArray
                            let kid_Id = result.value(forKey: "kid_Id") as? String
                            let lessionTitle = result.value(forKey: "lessionTitle") as? String
                            let lessonId = result.value(forKey: "lessonId") as? String
                            let lstudentQuestions = result.value(forKey: "lstudentQuestions") as? NSArray
                            let lstudentsubject = result.value(forKey: "lstudentsubject") as? String
                            let lstudentvideo = result.value(forKey: "lstudentvideo") as? NSArray
                            
                            
                            let datalstudentsubject = self.asString(dataString: lstudentsubject!)
                            
                            print("datalstudentsubject ," , datalstudentsubject)
                            print("datalstudentsubject ," , learningbookData)
                        

                            self.favoriteBooks.append(MyFavoritesData(kid_Id: kid_Id!, learningbookData: learningbookData!, lessionTitle: lessionTitle!, lessonId: lessonId!, lstudentQuestions: lstudentQuestions!, lstudentsubject: datalstudentsubject as NSDictionary, lstudentvideo: lstudentvideo!))

                         }
        self.favouritesTableView.reloadData()
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
    
    @IBOutlet weak var deleteFavoritesBtn: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
