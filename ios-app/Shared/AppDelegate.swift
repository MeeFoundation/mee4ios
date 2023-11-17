//
//  AppDelegate.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 31.10.23..
//

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    var core = MeeAgentStore()
    let center = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        center.delegate = self
        registerBackgroundTask()
        return true
    }

    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("notification received")
//        Task {
//            await core.getAllContexts()
//        }
//        completionHandler([])
//    }
    
    
    

    
    private func registerBackgroundTask() {
        print("registering background task")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "foundation.mee.extensionsync", using: nil) { task in
            print("syncronizing app end extension: ", Date().iso8601withFractionalSeconds)
            Task {
                
                await self.syncAppAndExtension()
                print("task completed")
                scheduleAppRefresh()
                task.setTaskCompleted(success: true)
            }
            
        }
    }
    
    
    
    func syncAppAndExtension() async {
        let _ = await self.core.getAllConnectors()

    }
}
