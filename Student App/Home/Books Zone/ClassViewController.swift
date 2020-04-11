//
//  ClassViewController.swift
//  Student App
//
//  Created by kalyan on 04/01/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit

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


    override func viewDidLoad() {
        buttons = [nurseryBtnOutlet,lkgBtnOutlet , ukgBtnOutlet,firstBtnOutlet,secondBtnOutlet,thirdBtnOutlet,fourthBtnOutlet,fifthBtnOutlet,sixthBtnOutlet,seventhBtnOutlet,eigthBtnOutlet,ningthBtnOutlet,tenthBtnOutlet]

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getallClassBySeries()
        
    }
    
    func getallClassBySeries(){
        SProgress.show()

        SAPIController.shared.getClassBySeries(payload: [:]) { (result, errorMessage) in
            print("getSeriesOfBooks Response---- %@ /n %@", result,errorMessage)
            SProgress.hide()

            if let response = result as? [String:Any] {
                
                let booksObj = response["studentClass"] as? [[String:Any]]
                
                for (index, obj) in booksObj!.enumerated() {
                    self.classesList.append(classBySeriesObjcet(data: obj))
                    print("index",index)
                    let className = obj["className"] as! String

                    self.buttons[index].setBackgroundImage(UIImage(named: "classbuttonBg.png"), for: UIControl.State.normal)
                        self.buttons[index].setTitle(className,for: .normal)
                                self.buttons[index].tintColor = UIColor.black
                  

                }
            }
            
            print("seriesofBook", self.classesList)
            
            
            if let error = errorMessage {
                
            }else{
                
                
            }
            
        }
        
    }
    
    @IBAction func selectedClassBtnAction(_ sender: Any) {
        print((sender as AnyObject).tag)
        
        let index = (sender as AnyObject).tag - 1
        
        let currentLastItem = self.classesList[index]
        let className = currentLastItem.className
        
        if #available(iOS 10.0, *) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                  vc.className = className!
                  vc.seriesNameText = seriesName
                  vc.classNameLB?.text = className
                  self.present(vc, animated: true, completion: nil)
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
