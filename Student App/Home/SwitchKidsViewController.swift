//
//  SwitchKidsViewController.swift
//  Student App
//
//  Created by kalyan on 18/02/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

class SwitchKidsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var kidsTableView: UITableView!
       var kidsList = [KidObject]()
    var completion:((KidObject)->())?

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        
        self.setUpTableView()
        kidsTableView.reloadData()
    }
    func setUpTableView() {

        kidsTableView.register(UINib(nibName: String(describing: SwitchKidTableViewCell.self), bundle: nil), forCellReuseIdentifier: STableCellIdentifierKeys.switchKidCellKey)
    }
    
    @IBAction func closeButton_Action() {
        
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - TableView Delegates
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return kidsList.count
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 35
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell = tableView.dequeueReusableCell(withIdentifier: STableCellIdentifierKeys.switchKidCellKey, for: indexPath) as! SwitchKidTableViewCell
        
        cell.nameLabel.text =  kidsList[indexPath.row].studentName
        
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        completion?(kidsList[indexPath.row])
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
