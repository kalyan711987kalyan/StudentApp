//
//  VIewController+Util.swift
//  RetailerPayment
//
//  Created by kalyan on 14/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    //Hide textfield on tap outside
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    static func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
            }
        }
        return json
    }
    
    @IBAction func backButtonAction(_ unwindSegue: UIStoryboardSegue) {}

    
    func showAlertWithTitleInView(title: String, message: String, buttonCancelTitle: String,buttonOkTitle: String, completion: @escaping (Int?)->Void) {
        DispatchQueue.main.async {
            let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if buttonOkTitle.count>0 {
                let okAction: UIAlertAction = UIAlertAction(title: buttonOkTitle, style: .default) { action -> Void in
                    
                    completion(1)
                }
                actionSheetController.addAction(okAction)
            }
            if buttonCancelTitle.count>0 {
                let cancelAction: UIAlertAction = UIAlertAction(title: buttonCancelTitle, style: .cancel) { action -> Void in
                    completion(2)
                }
                actionSheetController.addAction(cancelAction)
            }
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func convertDateToString(_ date: Date) -> String {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: date)
        return dateString
    }
    
  
    
}
extension UITextField {
       func setLeftPaddingPoints(_ amount:CGFloat){
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.leftView = paddingView
           self.leftViewMode = .always
       }
       func setRightPaddingPoints(_ amount:CGFloat) {
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.rightView = paddingView
           self.rightViewMode = .always
       }
   }

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

extension UIImageView {
    
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
          contentMode = mode
          URLSession.shared.dataTask(with: url) { data, response, error in
              guard
                  let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
                  
                  else { return }
              DispatchQueue.main.async() {
                  self.image = image
                  
              }
              }.resume()
      }
      func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
          guard let url = URL(string: link) else { return }
          dowloadFromServer(url: url, contentMode: mode)
      }
    
    func load(url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let data = try? Data(contentsOf: url) {
                   if let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
    
//   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//   }
//   func downloadImage(from url: URL) {
//    print("url is",url)
//      getData(from: url) {
//         data, response, error in
//         guard let data = data, error == nil else {
//            return
//         }
//         DispatchQueue.main.async() {
//            self.image = UIImage(data: data)
//         }
//      }
//   }
    

    func setImageFromURl(stringImageUrl url: String){
        
        
        

          if let url = NSURL(string: url) {
             if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
             }
          }else{
            print("url is nil")
        }
       }
    
    func setImageFromUrl(ImageURL :String) {
           
          URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
             (data, response, error) -> Void in
             DispatchQueue.main.async {
                if let data = data {
                   self.image = UIImage(data: data)!
                }
             }
          }).resume()
       }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension String{
    func trimWhiteSpaces() -> String{
        return self.trimmingCharacters(in:.whitespaces).replacingOccurrences(of: " ", with: "")
    }
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    //Validate Email

    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
   
    
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = window.safeAreaInsets.bottom + 90
        } else {
            // Fallback on earlier versions
        }
        return sizeThatFits
    }
}
