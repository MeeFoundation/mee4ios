//
//  scheduleAppRefresh.swift
//  mee-extension
//
//  Created by Anthony Ivanov on 3.11.23..
//

import Foundation
import BackgroundTasks

func scheduleAppRefresh()  {
    print("schedule background task: ", Date().iso8601withFractionalSeconds)
    let request = BGAppRefreshTaskRequest(identifier: "extensionsync")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
    do {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}
