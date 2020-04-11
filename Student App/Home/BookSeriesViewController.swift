//
//  BookSeriesViewController.swift
//  Student App
//
//  Created by kalyan on 19/02/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class BookSeriesViewController: UIViewController {

    @IBOutlet var bookseriesTableView: UITableView!
    var bookList = [KidObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBookSeriesData()
        
    }
    
    func getBookSeriesData() {
        
        SAPIController.shared.getBookSeriesAPI(payload: [:]) { (result, errorMessage) in
                   print("getBookSeriesAPI Response---- %@ /n %@", result,errorMessage)
                   SProgress.hide()

                   if let error = errorMessage {
                       
                   }else{
                       

            }
               
        }
              
    }

    //MARK: - TableView Delegates
          
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return bookList.count
          }
          
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 35
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

              let cell = tableView.dequeueReusableCell(withIdentifier: STableCellIdentifierKeys.switchKidCellKey, for: indexPath) as! SwitchKidTableViewCell
           
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
