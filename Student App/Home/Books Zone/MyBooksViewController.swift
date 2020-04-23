//
//  MyBooksViewController.swift
//  Student App
//
//  Created by kalyan on 24/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

class MyBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //var bookseriesList : [BooksZone] = []
    var bookseriesList : [BooksZone] = [BooksZone]()

    private let cache = NSCache<NSString, UIImage>()

    // var animals = [jags , news]
    var booksUrlArray = [String]()
    var imagesToLoad = [UIImage]()
    
    @IBOutlet var booksTableView: UITableView!
    
    var customerList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This view controller itself will provide the delegate methods and row data for the table view.
        booksTableView.delegate = self
        booksTableView.dataSource = self
        
        getSeriesOfBooks()
    
    }
   

    
    func getSeriesOfBooks() {
        SProgress.show()

        SAPIController.shared.getSeriesOfBooks(payload: [:]) { (result, errorMessage) in
            print("getSeriesOfBooks Response---- %@ /n %@", result,errorMessage)
            SProgress.hide()
            // guard let number = anOptionalInt else {
            if let response = result as? [String:Any] {
               // var booksData: [BooksZone] = []
                
                let booksObj = response["series"] as? [[String:Any]]
                
                booksObj?.forEach({ (obj) in
                    self.bookseriesList.append(BooksZone(data: obj))
                    self.booksUrlArray.append(obj["logo"] as! String)
                    
                })
            }
            
            self.booksTableView.reloadData()
            
            if let error = errorMessage {
                
            }else{
                
                
            }
            
        }
        
    }
   
    
    //MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookseriesList.count //customerList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookSeriesCell", for: indexPath) as! MyBookSeriesTableViewCell
        

        if self.bookseriesList.count > 0 {
            
          let currentLastItem = self.bookseriesList[indexPath.row]
          let logoURL = currentLastItem.logo

         cell.bookseriesImageView?.dowloadFromServer(link: logoURL!, contentMode: .scaleAspectFit)
            
        }
    
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClassViewController") as! ClassViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        let currentLastItem = self.bookseriesList[indexPath.row]
        let series = currentLastItem.series
        vc.seriesName = series!
        vc.seriesId = currentLastItem.id
        self.present(vc, animated: true, completion: nil)

        
        //self.performSegue(withIdentifier: SSegueKeys.bookseriesToClasslist, sender: self.bookseriesList[indexPath.row])
    }
   
    
}

