//
//  DashboardViewController.swift
//  Student App
//
//  Created by kalyan on 23/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift




@available(iOS 10.0, *)
class DashboardViewController: UIViewController,  SlideMenuControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var titleLabel: UILabel!
    
    var selectedKid: KidObject?
    var kidsList: [KidObject] = []
    var parentObject: ParentObject?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.slideMenuController()?.delegate = self
        self.slideMenuController()?.addLeftGestures()
        self.selectedKid = kidsList.first
        print("selectedKid id",selectedKid?.id as Any)

        UserDefaults.standard.set(selectedKid?.id, forKey: "selectedKid") //Bool
        //Store kid and parent data to coredata
        storeUserDataToCoredata(parentData: self.parentObject!, kidsData: kidsList)
        
        getBannerDetails()
        //SlideMenuOptions.contentViewScale = 0.50
    }
    
    func storeUserDataToCoredata(parentData : ParentObject , kidsData : [KidObject]){
        print("parent data",parentData)
        print("kidData data",kidsData)
        
        for kid in kidsData {
                    var kidDataDic = NSMutableDictionary()
            kidDataDic = ["kidName":kid.studentName!,"kidclass":kid.className!,"kidschool":kid.school! , "kid_id" :kid.id!]
            self.appDelegate!.insertNewRecord(withData : kidDataDic , userId : kid.id , inentity : "KidsData")
        }
    }
    
    
    @IBAction func myBooksButton_Action() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadedBooksViewController") as! DownloadedBooksViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)

        //self.performSegue(withIdentifier: SSegueKeys.dashboardtobookseriesKey, sender: nil)
        //self.performSegue(withIdentifier: SSegueKeys.home2mybooksKey, sender: nil)
    }
    
    @IBAction func switchKidButton_Action() {
        
        if let modalViewController = self.storyboard!.instantiateViewController(withIdentifier: "SwitchKidsViewController") as? SwitchKidsViewController {
            modalViewController.kidsList = self.kidsList
            modalViewController.view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
            
            modalViewController.completion = { kidDict in
                self.selectedKid = kidDict
                UserDefaults.standard.set(self.selectedKid?.id, forKey: "selectedKid") //Bool
            }
            
        }
    }
    
    @IBAction func libraryButton_Action() {
//        let modalViewController = self.storyboard!.instantiateViewController(withIdentifier: "SubjectViewController")
//        modalViewController.view.backgroundColor = UIColor.black
//        modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "dash2segue", sender: nil)
        self.performSegue(withIdentifier: SSegueKeys.home2mybooksKey, sender: nil)

    }
    
    @IBAction func openMenuButton_Action(){
        
        self.slideMenuController()?.openLeft()
    }
    
    func getBannerDetails() {
        
        SAPIController.shared.getBannerDetailsAPI(payload: [:]) { (result, errorMessage) in
                   print("getBannerDetailsAPI Response---- %@ /n %@", result,errorMessage)
                   SProgress.hide()

                   if let error = errorMessage {
                       
                   }else{
                       

            }
               
        }
    }
    
    private func updateSelectedKidInfromation(){
        
        if let nav = self.slideMenuController()?.leftViewController as? UINavigationController {
            let menuVc = nav.viewControllers.first as? MenuViewController
            menuVc?.emailLabel.text = parentObject?.email
            menuVc?.nameLabel.text =  selectedKid?.studentName
            menuVc?.schoolNameLabel.text = "\(String(describing: selectedKid?.className)), \(String(describing: selectedKid?.school))"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
    }

}


@available(iOS 10.0, *)
extension DashboardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collecviewBookCell", for: indexPath)

        return cell
    }
}


