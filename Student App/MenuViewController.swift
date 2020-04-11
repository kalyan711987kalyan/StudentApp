//
//  MenuViewController.swift
//  Student App
//
//  Created by kalyan on 23/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var schoolNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpTableView()
    }
    
    func setUpTableView() {

          menuTableView.register(UINib(nibName: String(describing: MenuTableViewCell.self), bundle: nil), forCellReuseIdentifier: STableCellIdentifierKeys.menuCellKey)
      }
      
      //MARK: - TableView Delegates
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 5 //customerList.count
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 60
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

          let cell = tableView.dequeueReusableCell(withIdentifier: STableCellIdentifierKeys.menuCellKey, for: indexPath) as! MenuTableViewCell

        switch indexPath.row {
        case 0:
            cell.menuImageView.image = UIImage(named: "callicon")
            cell.titleLabel.text = "Contact Us"
            break
        case 1:
            cell.menuImageView.image = UIImage(named: "mailicon")
            cell.titleLabel.text = "Feedback"
            break
        case 2:
            cell.menuImageView.image = UIImage(named: "passwordicon")
            cell.titleLabel.text = "Change Password"
            break
        case 3:
            cell.menuImageView.image = UIImage(named: "shareicon")
            cell.titleLabel.text = "Share"
            break
        case 4:
            cell.menuImageView.image = UIImage(named: "shareicon")
            cell.titleLabel.text = "Manage Kids"
            break
        default:
            break
        }
          
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            if #available(iOS 10.0, *) {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "ManageKidsViewController") as! ManageKidsViewController
                //let goViewController = UINavigationController(rootViewController: next)
                next.modalPresentationStyle = .fullScreen
                

                 self.present(next, animated: true, completion: nil)

            } else {
                // Fallback on earlier versions
            }
        }
        

        
//       if let vc = self.storyboard!.instantiateViewController(withIdentifier: "ManageKidsViewController") as? ManageKidsViewController {
//
//        let goViewController = UINavigationController(rootViewController: vc)
//
//        self.slideMenuController()?.changeMainViewController(goViewController, close: true)
//
//        }
          //self.performSegue(withIdentifier: "menutomanageKid", sender:nil)
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
