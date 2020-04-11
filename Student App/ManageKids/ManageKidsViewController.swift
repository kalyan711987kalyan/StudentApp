//
//  ManageKidsViewController.swift
//  Student App
//
//  Created by kalyan on 19/02/20.
//  Copyright © 2020 kalyan. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class ManageKidsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    
    let cellReuseIdentifier = "surveyListTableviewCell"
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var kidsDataTableView: UITableView!
    private var floatingButton: UIButton?
    // TODO: Replace image name with your own image:
    private let floatingButtonImageName = "plus.png"
    private static let buttonHeight: CGFloat = 50.0
    private static let buttonWidth: CGFloat = 50.0
    private let roundValue = ManageKidsViewController.buttonHeight/2
    private let trailingValue: CGFloat = 15.0
    private let leadingValue: CGFloat = 15.0
    private let shadowRadius: CGFloat = 2.0
    private let shadowOpacity: Float = 0.5
    private let shadowOffset = CGSize(width: 0.0, height: 5.0)
    private let scaleKeyPath = "scale"
    private let animationKeyPath = "transform.scale"
    private let animationDuration: CFTimeInterval = 0.4
    private let animateFromValue: CGFloat = 1.00
    private let animateToValue: CGFloat = 1.05
    
    var kidNameList: [String] = []
    var kidClassList: [String] = []
    var kidSchoolList: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let parentID = UserDefaults.standard.string(forKey: "parentEmail")
            else { return print("No data") }
        let results = self.appDelegate!.getAllRecordsforValue(valueof: parentID, forattribute: "parent_Id" , forEntity : "KidsData")
        for result in results {
            let formNameIs = result.value(forKey: "kidName") as? String
            let className = result.value(forKey: "kidClass") as? String
            let kidSchool = result.value(forKey: "kidSchool") as? String
            
            
            kidNameList.append(formNameIs!)
            kidClassList.append(className!)
            kidSchoolList.append(kidSchool!)
            kidsDataTableView.delegate = self
            kidsDataTableView.dataSource = self
            kidsDataTableView.reloadData()
            
            //print(formNameIs!)
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        createFloatingButton()
        
    }
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.backgroundColor = .white
        floatingButton?.setImage(UIImage(named: floatingButtonImageName), for: .normal)
        floatingButton?.addTarget(self, action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
        constrainFloatingButtonToWindow()
        makeFloatingButtonRound()
        addShadowToFloatingButton()
        addScaleAnimationToFloatingButton()
    }
    // TODO: Add some logic for when the button is tapped.
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddKidViewController") as! AddKidViewController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
            print("Button Tapped")
        } else {
            // Fallback on earlier versions
        }
        //let goViewController = UINavigationController(rootViewController: next)
        
    }
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow,
                let floatingButton = self.floatingButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: self.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: self.leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                ManageKidsViewController.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                ManageKidsViewController.buttonHeight).isActive = true
        }
    }
    
    private func makeFloatingButtonRound() {
        floatingButton?.layer.cornerRadius = roundValue
    }
    
    private func addShadowToFloatingButton() {
        floatingButton?.layer.shadowColor = UIColor.black.cgColor
        floatingButton?.layer.shadowOffset = shadowOffset
        floatingButton?.layer.masksToBounds = false
        floatingButton?.layer.shadowRadius = shadowRadius
        floatingButton?.layer.shadowOpacity = shadowOpacity
    }
    private func addScaleAnimationToFloatingButton() {
        // Add a pulsing animation to draw attention to button:
        DispatchQueue.main.async {
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: self.animationKeyPath)
            scaleAnimation.duration = self.animationDuration
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = self.animateFromValue
            scaleAnimation.toValue = self.animateToValue
            self.floatingButton?.layer.add(scaleAnimation, forKey: self.scaleKeyPath)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func manageKidsBackButtonAction(_ sender: Any) {
        floatingButton?.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kidNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KidsListTableViewCell", for: indexPath) as! KidsListTableViewCell
        cell.kidNameValueLB.text = self.kidNameList[indexPath.row]
        cell.kidClassValueLB.text = self.kidClassList[indexPath.row];
        
        cell.kidSchoolValueLB.text = self.kidSchoolList[indexPath.row];
        
        // cell.surveyListcellDelegate = self
        return cell
        
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
