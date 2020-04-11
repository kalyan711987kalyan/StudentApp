//
//  AppDelegate.swift
//  Student App
//
//  Created by kalyan on 23/12/19.
//  Copyright © 2019 kalyan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import UserNotifications
import CoreData

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    var window: UIWindow?
    var navigationController: SlideMenuController?
    var managedObjectContext: NSManagedObjectContext?
    var managedObjectModel: NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?

    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           // Override point for customization after application launch.
        showDashboard()
        managedObjectContext = self.persistentContainer.viewContext

        self.registerNotification {
            
        }
           return true
       }
    
    func registerNotification(completion: @escaping () -> Void){
           
           if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
                   UNUserNotificationCenter.current().delegate = self
                   
                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                   UNUserNotificationCenter.current().requestAuthorization(
                       options: authOptions,
                       completionHandler: {_, _ in
                           completion()
                   })
               } else {
                   let settings: UIUserNotificationSettings =
                       UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                   UIApplication.shared.registerUserNotificationSettings(settings)
                   completion()
               }
               UIApplication.shared.registerForRemoteNotifications()
       }
       

    public func showDashboard(){

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let leftViewController = storyboard.instantiateViewController(withIdentifier: "navigation1") as? UINavigationController,
            let mainViewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "loginroot") as? UINavigationController {
           // let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
           // UIApplication.shared.delegate?.window??.rootViewController = slideMenuController
            
//            self.navigationController = self.window?.rootViewController as? SlideMenuController
            let screenSize: CGRect = UIScreen.main.bounds
            SlideMenuOptions.leftViewWidth = screenSize.width * 0.85
            
             let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
               self.window?.rootViewController = slideMenuController
               self.window?.makeKeyAndVisible()
            


        }
    }

       func applicationWillResignActive(_ application: UIApplication) {
           // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
           // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
       }

       func applicationDidEnterBackground(_ application: UIApplication) {
           // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
           // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       }

       func applicationWillEnterForeground(_ application: UIApplication) {
           // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
       }

       func applicationDidBecomeActive(_ application: UIApplication) {
           // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       }

       func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       }
    
    
    //MARK - Remote Notification Delegates
       func application(_ application: UIApplication,
                        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           let tokenParts = deviceToken.map{ data -> String in
               return String(format: "%02.2hhx", data)
           }
           let token = tokenParts.joined()

        print("Device Token: \(token)")

    }
       func application(_ application: UIApplication,
                        didFailToRegisterForRemoteNotificationsWithError error: Error) {
           print("Failed to register: \(error)")
       }
       
       //First for foreground
       @available(iOS 10.0, *)
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
       {

        completionHandler([.alert, .sound])
       }
       @available(iOS 10.0, *)
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
       {
           //print("Handle push from background or closed")
           // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
           //print("\(response.notification.request.content.userInfo)")
           let userInfo = response.notification.request.content.userInfo

        completionHandler()
       }
    
    
     // MARK: - Core Data stack

        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: "StudentList")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

        // MARK: - Core Data Saving support

        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func insertNewRecord(withData : NSMutableDictionary , userId : String , inentity : String){
        print ("yes you are here");
        
        //check for KidId before inserting
        //var results : NSArray = []
        var results = [NSManagedObject]()

        if inentity == "KidsData" {
            results = self.getAllRecordsforValue(valueof: userId, forattribute: "kid_Id", forEntity: "KidsData")
        }

        if results.count == 0 {
        let kidname = withData.value(forKey: "kidName")
        let kidschool = withData.value(forKey: "kidschool")
        let kidclass = withData.value(forKey: "kidclass")
        let kid_id = withData.value(forKey: "kid_id")
        
         guard let userEntity = NSEntityDescription.entity(forEntityName: inentity, in: managedObjectContext!) else {
                    return
        
                }
        let user = NSManagedObject(entity: userEntity, insertInto: managedObjectContext)
                // save new appointmnet
                user.setValue(kid_id, forKey: "kid_Id")
                user.setValue(kidclass, forKey: "kidClass")
        user.setValue(kidname, forKey: "kidName")
        user.setValue(kidschool, forKey: "kidSchool")
        user.setValue(userId, forKey: "parent_Id")

          do{
            try managedObjectContext!.save()
                } catch let error as NSError{
                    print("COULD NOT SAVE , \(error) , \(error.userInfo)")
                }
        }
        
    }
    
    func downloadBookToCoreData(withbookData : String  , kid_id : String , parent_id : String , book_id : String) -> Bool{
        print ("yes you are here");
        
         guard let userEntity = NSEntityDescription.entity(forEntityName: "DownloadedBooks", in: managedObjectContext!) else {
                    return false
        
                }
        let user = NSManagedObject(entity: userEntity, insertInto: managedObjectContext)
                // save new appointmnet
                user.setValue(withbookData, forKey: "bookData")
                user.setValue(kid_id, forKey: "kid_Id")
                user.setValue(parent_id, forKey: "parent_Id")
                user.setValue(book_id, forKey: "book_id")


          do{
            try managedObjectContext!.save()
             return true
                } catch let error as NSError{
                    
                    print("COULD NOT SAVE , \(error) , \(error.userInfo)")
                    return false
                }
        }
        

    func getAllRecordsforValue(valueof: String ,forattribute: String , forEntity : String) -> [NSManagedObject] {
        //var error: Error?
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: forEntity, in: managedObjectContext!)
        let predicate = NSPredicate(format: "\(forattribute)=%@", valueof)
        request.predicate = predicate
        //var objectUpdate = NSManagedObject()
        var results = [NSManagedObject]()
        do {
            results = try managedObjectContext!.fetch(request) as! [NSManagedObject]

           // objectUpdate = results[0]

        }catch let error {
               print(error.localizedDescription)
            }
        return results

    }
    
   
    
    func deleteRecordforValue(valueof: String ,forattribute: String , forEntity : String) -> Bool {
           //var error: Error?
           let request = NSFetchRequest<NSFetchRequestResult>()
           request.entity = NSEntityDescription.entity(forEntityName: forEntity, in: managedObjectContext!)
           let predicate = NSPredicate(format: "\(forattribute)=%@", valueof)
           request.predicate = predicate
           //var objectUpdate = NSManagedObject()
           var results = true
           do {
               //results = try managedObjectContext!.fetch(request) as! [NSManagedObject]
            
            if let result = try? managedObjectContext!.fetch(request) {
                   for object in result {
                    managedObjectContext!.delete(object as! NSManagedObject)
                    
                   }
               }
              // objectUpdate = results[0]

           }catch let error {
                  print(error.localizedDescription)
            results = false
               }
           return results

       }
    
    func deleteAllRecordsOfKid(valueof: String ,forattribute: String , forEntity : String) -> Bool {
              //var error: Error?
              let request = NSFetchRequest<NSFetchRequestResult>()
              request.entity = NSEntityDescription.entity(forEntityName: forEntity, in: managedObjectContext!)
              let predicate = NSPredicate(format: "\(forattribute)=%@", valueof)
              request.predicate = predicate
              //var objectUpdate = NSManagedObject()
              var results = true
              do {
                  //results = try managedObjectContext!.fetch(request) as! [NSManagedObject]
               
               if let result = try? managedObjectContext!.fetch(request) {
                      for object in result {
                       managedObjectContext!.delete(object as! NSManagedObject)
                       
                      }
                  }
                 // objectUpdate = results[0]
              }catch let error {
                     print(error.localizedDescription)
               results = false
                  }
              return results

          }
    
    
    
    /*
    func getAllRecordsInTable(forEntity : String , parent_id : String) -> [NSManagedObject]? {
              var _: Error?
              let request = NSFetchRequest<NSFetchRequestResult>()
              request.entity = NSEntityDescription.entity(forEntityName: forEntity, in: managedObjectContext!)
        let predicate = NSPredicate(format: "\(forattribute)=%@", parent_id)
        request.predicate = predicate

        var results = [NSManagedObject]()
        do {
            results = try managedObjectContext!.fetch(request) as! [NSManagedObject]

                  // objectUpdate = results[0]

               }catch let error {
                      print(error.localizedDescription)
                   }
               return results

              //return try? managedObjectContext!.fetch(request)
          }
 */
    
//
//    func insertNewRecordofControlNumber(_ withValue: NSMutableDictionary , at controlNumber: String , forKey: String) {
    
//        let username = withValue.value(forKey: "userNameAT")
//        let uniqueid = withValue.value(forKey: "uniqueIdAT")
//        let restroomdata = withValue.value(forKey: "restRoomAT")
//        let emailid = withValue.value(forKey: "emailIdAT")
//        let breakData = withValue.value(forKey: "breakRoomAT")
//        let officedata = withValue.value(forKey: "officeRoomAT")
//        let formdata = withValue.value(forKey: "praposalFormAT")
//       // let appointmnet = withValue.value(forKey: "appointmentInServerAT")
//
//        guard let userEntity = NSEntityDescription.entity(forEntityName: "UsersList", in: managedObjectContext!) else {
//            return
//
//        }
//        let user = NSManagedObject(entity: userEntity, insertInto: managedObjectContext)
//        // save new appointmnet
//        user.setValue(username, forKey: "userNameAT")
//        user.setValue(uniqueid, forKey: "uniqueIdAT")
//        user.setValue(restroomdata, forKey: "restRoomAT")
//        user.setValue(emailid, forKey: "emailIdAT")
//        user.setValue(breakData, forKey: "breakRoomAT")
//        user.setValue(officedata, forKey: "officeRoomAT")
//        user.setValue(formdata, forKey: "praposalFormAT")
//        user.setValue("Turn back", forKey: "turnBackAT")
//        user.setValue("YES", forKey: "appointmentInServerAT")
//
//        do{
//            try managedObjectContext!.save()
//
//        } catch let error as NSError{
//            print("COULD NOT SAVE , \(error) , \(error.userInfo)")
//        }
//    }
    


    }



extension UIApplication{
    
    func registerForPushNotifications(completion: @escaping () -> Void){
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in

                    completion()
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.registerUserNotificationSettings(settings)
        }

        self.registerForRemoteNotifications()
        completion()

    }
}
