//
//  LearningActivityViewController.swift
//  Student App
//
//  Created by kalyan on 25/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

class LearningActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var learningTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


       
        let cellIdentifier = String(describing: LearningTableViewCell.self)
        learningTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let sectionIdentifier = String(describing: LearningActivitySectionView.self)
        self.learningTableView.register(UINib(nibName: sectionIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionIdentifier)
               

    }
    

    //MARK: - TableView Delegates
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //customerList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionIdentifier = String(describing: LearningActivitySectionView.self)
       let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionIdentifier)
       return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LearningTableViewCell.self), for: indexPath) as! LearningTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //self.performSegue(withIdentifier: RSegueKeys.list2invoiceKey, sender: customerList[indexPath.row])
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
