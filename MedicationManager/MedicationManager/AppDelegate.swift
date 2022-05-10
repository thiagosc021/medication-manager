//
//  AppDelegate.swift
//  MedicationManager
//
//  Created by Thiago Costa on 4/25/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { authorized, error in
            if let error = error {
                print("🔴 error requesting notification authorization: \(error)")
            }
            
            if authorized {
                UNUserNotificationCenter.current().delegate = self
                self.setNotificationCategories()
                    print("✅ authorization granted")
            } else {
                    print("🔴 autorization denied")
            }            
        }
        
        return true
    }
    
    func setNotificationCategories() {
        let markTakenAction = UNNotificationAction(identifier: Strings.notificationMarkTakenActionIdentifier, title: "I took it!", options: [.authenticationRequired])
        let ignoreAction = UNNotificationAction(identifier: Strings.notificationIgnoreActionIdentifier, title: "I'll take it later", options: [.authenticationRequired])
        let category = UNNotificationCategory(identifier: Strings.notificationCategoryIdentifier,
                                              actions: [markTakenAction, ignoreAction],
                                              intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: "",
                                              options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.medicationReminderReceived), object: self)
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.actionIdentifier == Strings.notificationMarkTakenActionIdentifier,
           let medicationId = response.notification.request.content.userInfo[Strings.medicationEntityIDKey] as? String else {
            completionHandler()
            return
        }
        MedicationController.shared.markAsTaken(with: medicationId)
        completionHandler()
    }
}
