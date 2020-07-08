//
//  DashboardViewController.swift
//  Student App
//
//  Created by kalyan on 23/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import AVFoundation


@available(iOS 10.0, *)
class DashboardViewController: UIViewController,  SlideMenuControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var kidNameTitleLB: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var titleLabel: UILabel!
    
    //var timer = Timer()
    var timer:Timer?

    
    var selectedKid: KidObject?
    var kidsList: [KidObject] = []
    var parentObject: ParentObject?
    var bannerImage : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.slideMenuController()?.delegate = self
        self.slideMenuController()?.addLeftGestures()
        self.selectedKid = kidsList.first
        print("selectedKid id",selectedKid?.id as Any)

        UserDefaults.standard.set(selectedKid?.id, forKey: "selectedKid") //Bool
        //Store kid and parent data to coredata
        if let response =  UserDefaults.standard.value(forKey: "parentData") as? [String:Any] {
            
            var kidsData: [KidObject] = []
             if let kidsObj = response["kidsData"] as? [[String:Any]]{
                 kidsObj.forEach({ (obj) in
                     kidsData.append(KidObject(data: obj))
                 })
             }else if let kidsObj = response["kidsData"] as? [String:Any] {
                 kidsData.append(KidObject(data: kidsObj))
             }
             kidsList = kidsData
            self.parentObject =  ParentObject(data: response)
            storeUserDataToCoredata(parentData: self.parentObject!, kidsData: kidsList)

        }
        getBannerDetails()
        self.kidNameTitleLB.text = "Hi, \(self.selectedKid?.studentName! ?? "")"

        
        if let modalViewController = self.storyboard!.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController, UserDefaults.standard.bool(forKey: RDataKeys.isInstalled) == false {
                   modalViewController.howtouseLink = "https://www.youtube.com/watch?v=CUXuyfFVQEA"
            modalViewController.websiteLink = UserDefaults.standard.value(forKey: "supportwebsite") as? String ?? "http://www.google.com"
                   modalViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                   modalViewController.modalPresentationStyle = .overCurrentContext
                  UserDefaults.standard.set(true, forKey: RDataKeys.isInstalled)
                   present(modalViewController, animated: true, completion: nil)
                   modalViewController.completion = {
                       print("Dailogclosed")
                    self.switchKidButton_Action()

            }
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        //SlideMenuOptions.contentViewScale = 0.50
    }
    
    func storeUserDataToCoredata(parentData : ParentObject , kidsData : [KidObject]){
        print("parent data",parentData)
        print("kidData data",kidsData)
        
        for kid in kidsData {
                    var kidDataDic = NSMutableDictionary()
            kidDataDic = ["kidName":kid.studentName!,"kidclass":kid.className!,"kidschool":kid.school! , "kid_id" :kid.id! , "parentId" : parentObject?.id! as Any]
            self.appDelegate!.insertNewRecord(withData : kidDataDic , userId : kid.id , inentity : "KidsData")
        }
    }
    
    @IBAction func myBooksButton_Action() {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadedBooksViewController") as! DownloadedBooksViewController
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(vc, animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 3

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
                self.kidNameTitleLB.text = "Hi, \(self.selectedKid?.studentName! ?? "")"

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
       // self.performSegue(withIdentifier: SSegueKeys.home2mybooksKey, sender: nil)
        self.tabBarController?.selectedIndex = 1


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let timer =  self.timer {
            self.timer!.invalidate()
        }
    }
    
    @IBAction func openMenuButton_Action(){
        
        self.slideMenuController()?.openLeft()
    }
    
    func getBannerDetails() {
        
        SProgress.show()
        
        SAPIController.shared.getBannerDetailsAPI(payload: [:]) { (result, errorMessage) in
                   print("getBannerDetailsAPI Response---- %@ /n %@", result,errorMessage)
            
            self.getContactDetails()
            if let response = result as? [String:Any] {
               // var booksData: [BooksZone] = []
                
                let booksObj = response["banner"] as? [[String:Any]]
                
                booksObj?.forEach({ (obj) in
                    self.bannerImage.append(obj["bannerUrl"] as! String)
                   // self.booksUrlArray.append(obj["logo"] as! String)
            
                })
            }
            
            self.showImagesOnSlider()

                   if let error = errorMessage {
                    SProgress.hide()
                    self.showAlertWithTitleInView(title: "", message:error, buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}

                   }else{
                       

            }
               
        }
    }
    
    func getContactDetails()  {
        SAPIController.shared.getSupportDetails(payload: [:]) { (result, errorMessage) in
            
            if let response = result as? [String:Any] {
                           
                if let email = response["email"] as? String{
                    UserDefaults.standard.set(email, forKey: "supportemail") //string
                }
                if let mobile = response["primaryMobile"] as? String {
                    UserDefaults.standard.set(mobile, forKey: "supportmobile")

                }
                if let website = response["website"] as? String {
                    UserDefaults.standard.set(website, forKey: "supportwebsite")
                }
            }
        }
    }
    
    func showImagesOnSlider(){

           for i in 0..<bannerImage.count {

        let imageView = UIImageView()
            
            let url : NSString = bannerImage[i] as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let searchURL : NSURL = NSURL(string: urlStr as String)!
            let data = try? Data(contentsOf: searchURL as URL)
            
         //   cell.thumbnailImageView?.image =
        imageView.image = UIImage(data: data!)
        let xPosition = self.view.frame.width * CGFloat(i)
        imageView.frame = CGRect(x: xPosition, y: 0, width:
        self.imageScrollView.frame.width + 50, height: self.imageScrollView.frame.height)
        imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
        imageScrollView.addSubview(imageView)

         }
        
        SProgress.hide()


        self.imageScrollView.delegate = self
        scheduledTimerWithTimeInterval()
        SProgress.hide()
    }
    @objc func animateScrollView() {
        let scrollWidth = imageScrollView.bounds.width
        let currentXOffset = imageScrollView.contentOffset.x

        let lastXPos = currentXOffset + scrollWidth
        if lastXPos != imageScrollView.contentSize.width {
            print("Scroll")
            imageScrollView.setContentOffset(CGPoint(x: lastXPos, y: 0), animated: true)
        }
        else {
            print("Scroll to start")
            imageScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
  func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.animateScrollView), userInfo: nil, repeats: true)
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


