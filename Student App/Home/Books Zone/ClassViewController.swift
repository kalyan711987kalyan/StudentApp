//
//  ClassViewController.swift
//  Student App
//
//  Created by kalyan on 04/01/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import Alamofire
class ClassViewController: UIViewController   {
    
    var classesList : [classBySeriesObjcet] = [classBySeriesObjcet]()
    var seriesName : String = ""
    @IBOutlet weak var nurseryBtnOutlet: UIButton!
    @IBOutlet weak var lkgBtnOutlet: UIButton!
    @IBOutlet weak var ukgBtnOutlet: UIButton!
    @IBOutlet weak var firstBtnOutlet: UIButton!
    @IBOutlet weak var secondBtnOutlet: UIButton!
    @IBOutlet weak var thirdBtnOutlet: UIButton!
    @IBOutlet weak var fourthBtnOutlet: UIButton!
    @IBOutlet weak var fifthBtnOutlet: UIButton!
    @IBOutlet weak var sixthBtnOutlet: UIButton!
    @IBOutlet weak var seventhBtnOutlet: UIButton!
    @IBOutlet weak var eigthBtnOutlet: UIButton!
    @IBOutlet weak var ningthBtnOutlet: UIButton!
    @IBOutlet weak var tenthBtnOutlet: UIButton!
    var buttons = [UIButton]()
    var seriesId:String = ""

    override func viewDidLoad() {
        buttons = [nurseryBtnOutlet,lkgBtnOutlet , ukgBtnOutlet,firstBtnOutlet,secondBtnOutlet,thirdBtnOutlet,fourthBtnOutlet,fifthBtnOutlet,sixthBtnOutlet,seventhBtnOutlet,eigthBtnOutlet,ningthBtnOutlet,tenthBtnOutlet]

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getallClassBySeries()
        
    }
    
    func getallClassBySeries(){
        
        
        
            SProgress.show()
            let baseURLString = APIEndPoints.base.urlString
            
            guard let url = URL(string: baseURLString+"/API/class/getClassDetailsBySeries/"+seriesId) else {
                //completion(nil)
                return
            }
        print(url)
            Alamofire.request(url,
                              method: .get,
                              parameters: [:])
                .validate()
                .responseJSON { response in
                   SProgress.hide()
                    print(response.result.value)

                    if let responseDict = response.result.value as? [String:Any] {
                                   
                        if let booksObj = responseDict["studentClass"] as? [[String:Any]] {
                            for (index, obj) in booksObj.enumerated() {
                                self.classesList.append(classBySeriesObjcet(data: obj))
                                print("index",index)
                                let className = obj["className"] as! String

                                self.buttons[index].setBackgroundImage(UIImage(named: "classbuttonBg.png"), for: UIControl.State.normal)
                                    self.buttons[index].setTitle(className,for: .normal)
                                            self.buttons[index].tintColor = UIColor.black
                              

                            }
                            
                        }else{
                            self.showAlertWithTitleInView(title: "", message:"No books available in this series", buttonCancelTitle:"", buttonOkTitle: "OK"){ (index) in}
                            self.dismiss(animated: false, completion: nil)
                        }
                    
                                   
                               }
                    
            }
        
        
    }
    
    @IBAction func selectedClassBtnAction(_ sender: Any) {
        print((sender as AnyObject).tag)
        
        let index = (sender as AnyObject).tag - 1
        if index < self.classesList.count {
            let currentLastItem = self.classesList[index]
                 let className = currentLastItem.className
                 
                 if #available(iOS 10.0, *) {
                     let vc = self.storyboard?.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
                     vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                           vc.className = className!
                           vc.seriesNameText = seriesName
                           vc.classNameLB?.text = className
                           self.navigationController?.pushViewController(vc, animated: true)
                 }
        }
     

        //self.performSegue(withIdentifier: SSegueKeys.classToBooksList, sender: self.bookseriesList[indexPath.row])

        
        

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
