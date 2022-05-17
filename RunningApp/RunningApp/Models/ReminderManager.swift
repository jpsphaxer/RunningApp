//
//  ReminderManager.swift
//  RunningApp
//
//  Created by Kathy Bai on 4/15/22.
//

import Foundation
import UserNotifications

class ReminderManager{
    private var notificationTimeHr: Int
    private var notificationTimeMinute: Int
    
    init(timeHr: Int, timeMinute: Int) {
        notificationTimeHr = timeHr
        notificationTimeMinute = timeMinute
    }
    
    func triggerLocalNotification(title: String, body: String) {
        // Notification Content
        let content = UNMutableNotificationContent()
        content.body = body
        content.title = title
        content.sound = .default
        
        // Notification Trigger
        var dateComponent = DateComponents()
        dateComponent.hour = notificationTimeHr
        dateComponent.minute = notificationTimeMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // Notification Request
        let localNRequest = UNNotificationRequest(identifier: "local notification", content: content, trigger: trigger)
        
        // Notification add
        UNUserNotificationCenter.current().add(localNRequest) { (error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
            }else {
                NSLog("Notification Scheduled")
            }
        }
    }
}
