//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Thiago Costa on 5/5/22.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    
    static let shared = NotificationScheduler()
    
    private init() {}
    
    func scheduleNotifications(for medication: Medication) {
        guard let medicationId = medication.id else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = [Strings.medicationEntityIDKey: "\(medicationId)"]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour,.minute], from: medication.timeOfDay ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        
        let request = UNNotificationRequest(identifier: "\(medicationId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("something went wrong while trying to schedule the notification \(error.localizedDescription)")
            }
        }
        
    }
    
    func cancelNotifications(for medication: Medication) {
        guard let medicationId = medication.id else {
            return
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(medicationId)"])
    }
    
}
