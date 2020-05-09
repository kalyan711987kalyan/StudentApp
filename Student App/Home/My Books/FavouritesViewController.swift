//
//  FavouritesViewController.swift
//  Student App
//
//  Created by kalyan on 16/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

@available(iOS 10.0, *)
class FavouritesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  , delFavCellDelegate , delVideoCellDelegate, AVPlayerViewControllerDelegate{
    
    let playerViewController = AVPlayerViewController()
    @IBOutlet weak var videosTableview: UITableView!

    
    func diddeleteVideoButton(_ tag: Int) {
        
        
        self.showAlertWithTitleInView(title: "Delete?", message: "Do you want to delete This Video!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                  
                  if index == 1{
                      let delVid = self.downloadedVideos[tag]

                    let succeess = self.appDelegate!.deleteRecordforValue(valueof: delVid.id!, forattribute: "id", forEntity: "DownloadedVideos")

                      if succeess == true {
                        self.getAlreadyDownloadVideo()
                      }

            }
            
        }

    }
    
    func diddeleteFromFavButton(_ tag: Int) {
        
        
        self.showAlertWithTitleInView(title: "My Favs", message: "Do you want to remove this lesson!", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                  
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
        if tableView == self.favouritesTableView {
                    return self.favoriteBooks.count

        }else{
            return self.downloadedVideos.count

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.favouritesTableView {
            return 100
        }else{
            return 80
        }
           
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.favouritesTableView
        {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FavourtesTableViewCell", for: indexPath) as! FavourtesTableViewCell
        
        if self.favoriteBooks.count > 0 {
            
            cell.cellDelegate = self
            cell.favBTNOutlet?.tag = indexPath.row

            let favBook = self.favoriteBooks[indexPath.row]
            cell.favBTNOutlet?.setImage(UIImage(named: "favicon.png")! as UIImage, for: .normal)
            cell.lessonName?.text = favBook.lessionTitle
            cell.learningsLB?.text = "Learning : \(favBook.lstudentvideo.count)"
            let activities = favBook.lstudentQuestions
            cell.activityLB?.text = "Activities : \(activities.count)"

        }
               return cell
        }
        
        if tableView == self.videosTableview
        {
         let cell = tableView.dequeueReusableCell(withIdentifier: "VideosTableViewCell", for: indexPath) as! VideosTableViewCell
        
        if self.downloadedVideos.count > 0 {
            let videoData = self.downloadedVideos[indexPath.row]

           cell.cellDelegate = self
           cell.deleteVideoBtnOutlet?.tag = indexPath.row
            cell.videoNameLB?.text = videoData.videoName!
            cell.dataShowLb?.text = "\(videoData.videoSize!) MB"
            
        }
               return cell
        }
        
        return UITableViewCell()

        
    }
    
    
    @IBAction func deleteAllVideos(_ sender: Any) {
        
        self.showAlertWithTitleInView(title: "Delete?", message: "Do you want to delete all Downloaded Videos?", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                  

                  if index == 1{
                    
                    

                    let succeess = self.appDelegate!.deleteAllDataOfEntity(forEntity: "DownloadedVideos")

                      if succeess == true {
                        self.getAlreadyDownloadVideo()
                      }

            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.favouritesTableView {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivitesViewController") as! ActivitesViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        
        let lessonData = self.favoriteBooks[indexPath.row]
        vc.learningbookData = lessonData.learningbookData as! [String]
        vc.lessionTitle = lessonData.lessionTitle
        vc.lstudentsubject = lessonData.lstudentsubject
        vc.lstudentvideo = []
        vc.lstudentQuestions = []
        vc.lessionId = self.mylessonIdArray[indexPath.row] as! String
        //send status of favourite
        vc.isFavorite = true
        vc.studentSubject = self.mysubjectData[indexPath.row] as! String
            
            self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
        }
        if tableView == self.videosTableview {
            
            let results = self.downloadedVideos[indexPath.row]
            print(results.filePath)

            if let urlData = results.filePath, let url = URL(string: "https://drive.google.com/uc?id=1U-RCUEiYySNW5g3g5BbXSb6IB6z8aKU9&export=download") {

                    
//                   guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
//                       debugPrint( "\(file.joined(separator: ".")) not found")
//                       return
//                   }
                
                print(url)

                 let player = AVPlayer(url: url)

                playerViewController.player = player

                self.appDelegate!.orientation = .landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player!.play()
                }
                
//                let playerLayer = AVPlayerLayer(player: player)
//                    playerLayer.frame = self.allVideosView.bounds
//                    self.allVideosView.layer.addSublayer(playerLayer)
//                    player.play()
                
             }
        }
        
        
    }
    
    @IBAction func backButton_Action(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func videosBTN(_ sender: Any) {
        self.allFavouritesView.isHidden = true
        self.allVideosView.isHidden = false
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
    @IBOutlet weak var allVideosView: UIView!
    @IBAction func lessonBtn(_ sender: Any) {
        self.allFavouritesView.isHidden = false
        self.allVideosView.isHidden = true
    }
    @IBOutlet weak var lessonsView: UIView!
    @IBOutlet weak var favouritesTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var favoriteBooks = [MyFavoritesData]()
    var downloadedVideos = [downloadedVideo]()

    
    var mylessonIdArray = NSMutableArray()
    var mysubjectData = NSMutableArray()

    @IBOutlet weak var allFavouritesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
 //       NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)

        self.indexChanged(segmentedControl)
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
     self.playerViewController.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavouritesFromCoreData()
        getAlreadyDownloadVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate!.orientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.allFavouritesView.isHidden = false
                   self.allVideosView.isHidden = true
            break;
        case 1:
            self.allFavouritesView.isHidden = true
            self.allVideosView.isHidden = false
            break;
        default:
            break
        }
    }
    
    func getAlreadyDownloadVideo(){
        self.downloadedVideos.removeAll()
        
        let results = self.appDelegate!.getAllRecordsforValue(valueof: "", forattribute: "", forEntity: "DownloadedVideos")
          
          for result in results {
                     let vidId = result.value(forKey: "id") as? String
            let videoUrl = result.value(forKey: "videoUrl") as? String
            let videoSize = result.value(forKey: "videoSize") as? String
            let videoNameFormated = result.value(forKey: "videoNameFormated") as? String
            let videoName = result.value(forKey: "videoName") as? String
            let lessonId = result.value(forKey: "lessonId") as? String
            let filePath = result.value(forKey: "filePath") as? String
            
            self.downloadedVideos.append(downloadedVideo(id: vidId!, videoName: videoName!, filePath: filePath!, lessonId: lessonId!, videoNameFormated: videoNameFormated!, videoSize: videoSize!, videoUrl: videoUrl!))



                 }
          self.videosTableview.reloadData()

      }
    
    func getFavouritesFromCoreData(){
        self.mylessonIdArray.removeAllObjects()
        self.mysubjectData.removeAllObjects()
        self.favoriteBooks.removeAll()

        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }

        
        let  results = self.appDelegate!.getAllRecordsforValue(valueof: kidId, forattribute: "kid_Id", forEntity: "Favourites")
        
        if results.count == 0 {
            self.favoriteBooks.removeAll()
        }else{
                         for result in results {
                             
                             let learningbookData = result.value(forKey: "learningbookData") as? NSArray
                            let kid_Id = result.value(forKey: "kid_Id") as? String
                            let lessionTitle = result.value(forKey: "lessionTitle") as? String
                            let lessonId = result.value(forKey: "lessonId") as? String
                            let lstudentQuestions = result.value(forKey: "lstudentQuestions") as? NSArray
                            let lstudentsubject = result.value(forKey: "lstudentsubject") as? String
                            let lstudentvideo = result.value(forKey: "lstudentvideo") as? NSArray
                            
                            self.mylessonIdArray.add(lessonId as Any)
                            
                            self.mysubjectData.add(lstudentsubject as! String)

                            let datalstudentsubject = self.asString(dataString: lstudentsubject!)
                            
                            print("datalstudentsubject ," , datalstudentsubject)
                            print("datalstudentsubject ," , learningbookData)
                        

                            self.favoriteBooks.append(MyFavoritesData(kid_Id: kid_Id!, learningbookData: learningbookData!, lessionTitle: lessionTitle!, lessonId: lessonId!, lstudentQuestions: lstudentQuestions!, lstudentsubject: datalstudentsubject as NSDictionary, lstudentvideo: lstudentvideo!))

                         }
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
