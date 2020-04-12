//
//  ActivitesViewController.swift
//  Student App
//
//  Created by kalyan on 11/04/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ActivitesViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate , videoCellDelegate{
    func didDownloadPressButton(_ tag: Int) {
         self.showAlertWithTitleInView(title: "Download This Video?", message:"Download video shall be available in My Favs", buttonCancelTitle:"No", buttonOkTitle: "Yes"){ (index) in
                          if index == 1{
                              
                       
                              
                          }
                      }
    }
    
    
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
    
    var learningbookData : [String] = []
    var lstudentsubject : NSDictionary = [:]
    var lstudentvideo : NSArray = []
    var lstudentQuestions : NSArray = []
    var lessionTitle = String()
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
        
        self.viddeosTableView.reloadData()
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
            let dataValue = videoData["videoSize"]!
            
            cell.videoTitleBtn?.setTitle(videoData["videoName"]! as? String, for: UIControl.State.normal) // We are going to use the item name as the Button Title here.
            cell.dataCellLb?.text = "\(dataValue) MB"
            
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoData = self.lstudentvideo[indexPath.row] as! [String : Any]
        //let value = videoData["videoName"]!
        let dataValue = videoData["youtubeUrl"]! as! String
        let fullNameArr = dataValue.components(separatedBy: "/")
        playInYoutube(youtubeId: fullNameArr[3])
        
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
    }
    @IBAction func quiZBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
                      vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        vc.allQuizQuestions = lstudentQuestions
                  self.present(vc, animated: true, completion: nil)

        
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
