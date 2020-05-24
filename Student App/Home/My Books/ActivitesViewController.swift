//
//  ActivitesViewController.swift
//  Student App
//
//  Created by kalyan on 11/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import AVFoundation
@available(iOS 10.0, *)
class ActivitesViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate , videoCellDelegate{
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func didDownloadPressButton(_ tag: Int) {
        
        if let modalViewController = self.storyboard!.instantiateViewController(withIdentifier: "SubjectViewController") as? SubjectViewController {
            
            modalViewController.view.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
            
            modalViewController.titleLabel.text = "Download This Video?"
            
            modalViewController.descriptionLabel.text = "Downloaded video shall be available in My Favourite"
            modalViewController.completion = {
                
                DispatchQueue.global(qos: .background).async {

                let object = self.lstudentvideo[tag] as! [String : String]
                let videoImageUrl = object["videoUrl"]!
                let videoName = object["videoName"]!
                let id = object["id"]!
                let lessonId = object["lessonId"]!
                let videoSize = object["videoSize"]!
                let videoUrl = object["videoUrl"]!
                
                let filePath = self.appDelegate!.documentsPathForFileName(name: "\(self.randomString(length: 10)).mp4")
                print(filePath)
                if let url = URL(string: videoImageUrl),
                    let urlData = NSData(contentsOf: url) {
                        urlData.write(to: filePath, atomically: true)
                        
                        
                        self.appDelegate!.addVideoFavoriteToCoreData(withFilePath: "\(filePath)", id: id, lessonId: lessonId, videoName: videoName, videoSize: videoSize, videoUrl: videoUrl, videoNameFormated: "\(videoName).mp4") { (isSuccess) in
                            
                            if isSuccess == true {
                                let path = Bundle.main.path(forResource: "deleted.wav", ofType:nil)!
                                let url = URL(fileURLWithPath: path)
                                
                                do {
                                    self.bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                                    self.bombSoundEffect?.play()
                                } catch {
                                    // couldn't load file :(
                                }
                                DispatchQueue.main.async {
                                    modalViewController.indicator.stopAnimating()
                                    modalViewController.titleLabel.text = "Success!"
                                    modalViewController.descriptionLabel.text = "Video downloaded successfully."
                                }
                               
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            modalViewController.downloadCompletion = {
                self.getAlreadyDownloadVideo()
                self.dismiss(animated: false, completion: nil)
            }
            
        }
        
        /* self.showAlertWithTitleInView(title: "Download This Video?", message:"Download video shall be available in My Favs", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
         if index == 1{
         
         SProgress.show(in: self.view, message: "Downloading...")
         
         print("lstudentvideo",self.lstudentvideo[tag])
         let object = self.lstudentvideo[tag] as! [String : String]
         let videoImageUrl = object["videoUrl"]!
         let videoName = object["videoName"]!
         let id = object["id"]!
         let lessonId = object["lessonId"]!
         let videoSize = object["videoSize"]!
         let videoUrl = object["videoUrl"]!
         
         let filePath = self.appDelegate!.documentsPathForFileName(name: "\(self.randomString(length: 10)).mp4")
         
         if let url = URL(string: videoImageUrl),
         let urlData = NSData(contentsOf: url) {
         urlData.write(toFile: filePath, atomically: true)
         //Save in core data with any extra parameter
         // let isSuccess = self.appDelegate!.addVideoFavoriteToCoreData(withFilePath: filePath, id: id, lessonId: lessonId, videoName: videoName, videoSize: videoSize, videoUrl: videoUrl, videoNameFormated: "\(videoName).mp4")
         //  self.appDelegate!.addVideoFavoriteToCoreData(withbookData: "12", videoData: filePath)
         self.appDelegate!.addVideoFavoriteToCoreData(withFilePath: filePath, id: id, lessonId: lessonId, videoName: videoName, videoSize: videoSize, videoUrl: videoUrl, videoNameFormated: "\(videoName).mp4") { (isSuccess) in
         DispatchQueue.main.async {
         SProgress.hide(in: self.view)
         }
         if isSuccess == true {
         
         self.showAlertWithTitleInView(title: "Success!", message:"Video downloaded successfully.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in
         }
         }else{
         
         self.showAlertWithTitleInView(title: "Failed", message:"Failed to download.", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in
         
         }
         
         self.getAlreadyDownloadVideo()
         
         }
         
         
         }
         
         }else{
         DispatchQueue.main.async {
         SProgress.hide(in: self.view)
         }
         }
         }
         }*/
    }
    
    @IBOutlet weak var favouriteBtnOutlet: UIButton!
    @IBOutlet weak var mainTitleLb: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var seriesNameLB: UILabel!
    @IBOutlet weak var classNameLB: UILabel!
    @IBOutlet weak var bookNameNameLB: UILabel!
    @IBOutlet weak var subjectNameLB: UILabel!
    @IBOutlet weak var videoSizeNameLB: UILabel!
    
    @IBOutlet weak var viddeosTableView: UITableView!
    @IBOutlet weak var learningNameBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    var bombSoundEffect: AVAudioPlayer?

    var learningbookData : [String] = []
    var lstudentsubject : NSDictionary = [:]
    var lstudentvideo : NSArray = []
    var lstudentQuestions : NSArray = []
    var lessionTitle = String()
    var lessionId = String()
    var isFavorite = Bool()
    var studentSubject = String()
    var downloadedVideosId = NSMutableArray()
    let playerViewController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("learningbookData",learningbookData)
        self.seriesNameLB?.text = learningbookData[1]
        self.classNameLB?.text = learningbookData[2]
        self.bookNameNameLB?.text = learningbookData[0]
        self.subjectNameLB?.text = learningbookData[3]
        
        //self.learningNameBtn.setTitle(lstudentvideo.videoName, for: .normal)
        
        print("lstudentsubject",lstudentsubject)
        print("lstudentvideo",lstudentvideo)
        print("lstudentQuestions",lstudentQuestions)
        
        self.mainTitleLb?.text = "Lession: \(lessionTitle)"
        
        if isFavorite == true {
            self.favouriteBtnOutlet.setImage(UIImage(named: "favicon.png")! as UIImage, for: .normal)
        }else{
            self.favouriteBtnOutlet.setImage(UIImage(named: "love.png")! as UIImage, for: .normal)

        }
        self.getContentDetails(lessionid: lessionId)
        self.getAlreadyDownloadVideo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate!.orientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
       
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getAlreadyDownloadVideo(){
        
      let results = self.appDelegate!.getAllRecordsforValue(valueof: "", forattribute: "", forEntity: "DownloadedVideos")
        
        for result in results {
                   let vidId = result.value(forKey: "id") as? String
                   self.downloadedVideosId.add(vidId!)
               }
        self.viddeosTableView.reloadData()

    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    // With Alamofire
       func getContentDetails( lessionid : String ) {
          
           SProgress.show()
           let baseURLString = APIEndPoints.base.urlString
           
           guard let url = URL(string: baseURLString+"/API/content/getContentByLessonId/"+lessionid) else {
               //completion(nil)
               return
           }
           print(url)
           Alamofire.request(url,
                             method: .get,
                             parameters: ["include_docs": "true"])
               .validate()
               .responseJSON { response in
                SProgress.hide()
                print(response.result.value)
                   guard response.result.isSuccess else {
                       //print("Error while fetching remote rooms: \(String(describing: response.result.error)")
                       //completion(nil)
                       return
                   }
                   
                   if let response = response.result.value as? [String:Any] {
                       //let question = obj["studentQuestions"] as? NSArray ?? []

                    self.lstudentQuestions = response["studentQuestions"] as? NSArray ?? []
                    self.lstudentvideo = response["studentVideo"] as? NSArray ?? []
                    
                    if let imagesArray = response["studentVideo"] as? NSDictionary{
                        self.lstudentvideo = NSArray(object: imagesArray)
                    }else{
                                               
                        let nsArray = response["studentVideo"] as? NSArray ?? []
                        self.lstudentvideo = nsArray
                    }

                    self.viddeosTableView.reloadData()
                       
                       
                   }
           }
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lstudentvideo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitesTableViewCell", for: indexPath) as! ActivitesTableViewCell
        if self.lstudentvideo.count > 0 {
            let videoData = self.lstudentvideo[indexPath.row] as! [String : Any]
            //let value = videoData["videoName"]!
            cell.videoDelegate = self
            cell.downloadBtn?.tag = indexPath.row
            let videoId = videoData["id"]!

            if self.downloadedVideosId.contains(videoId) {
                         //do something
                cell.downloadBtn?.isHidden = true
            }else{
                cell.downloadBtn?.isHidden = false
            }
            
            
            let dataValue = videoData["videoSize"]!
            cell.videolessonTitleLB?.text = videoData["videoName"]! as! String
            cell.dataCellLb?.text = "\(dataValue) MB"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoData = self.lstudentvideo[indexPath.row] as! [String : Any]
        //let value = videoData["videoName"]!
        //let dataValue = videoData["youtubeUrl"]! as! String
       // let fullNameArr = dataValue.components(separatedBy: "/")
       // playInYoutube(youtubeId: fullNameArr[3])
        if let url = URL(string: videoData["videoUrl"] as? String ?? "") {
            let player = AVPlayer(url: url)
            playerViewController.player = player
            self.appDelegate!.orientation = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            self.present(playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
        }
        
        
    }
    func playInYoutube(youtubeId: String) {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func favouriteBtnAction(_ sender: Any) {
        
    guard let parentID = UserDefaults.standard.string(forKey: "parentEmail")
            else { return print("No data") }
        guard let kidId = UserDefaults.standard.string(forKey: "selectedKid")
            else { return print("No data") }
        
        
        var msg = String()
        var title = String()
        var flag = Int()
        
        if isFavorite == true {
            flag = 0
            title = "Remove as Favourite?"
            msg = "This lesson shall be removed to my Favs!"
        }else{
            flag = 1
            title = "Add to my Favs?"
            msg = "This lesson shall be added to my Favs!"
        }
        
        
        self.showAlertWithTitleInView(title: title, message: msg, buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
            
            

            if index == 1{
                
                //vc.learningbookData = bookData
//                let lessionTitle = lessonData.lessonName!
//                let lstudentsubject = lessonData.studentsubject
//                let lstudentvideo = lessonData.studentvideo
//                let lstudentQuestions = lessonData.studentQuestions
                var isSuccess : Bool = true
                
                if flag == 1 {
                    isSuccess = self.appDelegate!.addFavouriteToCoreData(withlessonData: self.learningbookData as NSArray, kid_id: kidId, parent_id: parentID, lessonId: self.lessionId, lessionTitle: self.lessionTitle, lstudentQuestions: self.lstudentQuestions, lstudentsubject: self.studentSubject , lstudentvideo: self.lstudentvideo)
                    self.favouriteBtnOutlet.setImage(UIImage(named: "favicon.png")! as UIImage, for: .normal)

                }else{
                    
                    isSuccess = self.appDelegate!.deleteRecordforValue(valueof: self.lessionId, forattribute: "lessonId", forEntity: "Favourites")

                    self.favouriteBtnOutlet.setImage(UIImage(named: "love.png")! as UIImage, for: .normal)

                }
            }else{
                
            }
        }
    
    }
    @IBAction func quiZBtnAction(_ sender: Any) {
        if lstudentQuestions.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
                               
            //vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                   vc.allQuizQuestions = lstudentQuestions
            self.navigationController?.pushViewController(vc, animated: true)

            //self.present(vc, animated: true, completion: nil)
        }else{
            self.showAlertWithTitleInView(title:"", message: "No quiz available", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in
            }
        }
       
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
