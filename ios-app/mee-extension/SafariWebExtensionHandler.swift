//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Roman Siliuk on 29.03.23.
//

import SafariServices
import os.log
import UserNotifications
import BackgroundTasks

let SFExtensionMessageKey = "message"
let SFExtensionMessageTypeKey = "type"

let extensionSharedDefaults = UserDefaults(suiteName: "group.extensionshare.foundation.mee.ios-client")

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        guard let item = context.inputItems[0] as? NSExtensionItem else {
            return
        }
        
        let meeExtensionQueueData = extensionSharedDefaults?.string(forKey: MEE_EXTENSION_QUEUE)
        let meeExtensionQueue = [MeeExtenstionEntry].fromString(meeExtensionQueueData) ?? []
        
        let message = item.userInfo?[SFExtensionMessageKey] as? [String: String]
        
        let innerMessage = message?[SFExtensionMessageKey] as? String
        let innerType = message?[SFExtensionMessageTypeKey] as? String
        
        var response: [String : Any]
        switch(innerType) {
        case "GET_DOMAIN_STATUS":
            guard let innerMessage else {
                response = [ "success": false, "gpcEnabled" : false]
                break
            }
            if let connectionString = extensionSharedDefaults?.string(forKey: innerMessage), let connection = MeeExtenstionEntry.fromString(connectionString) {
                let hasConnection = connection.gpcEnabled
                response = [ "success": true, "gpcEnabled" : hasConnection]
            }
            
            response = [ "success": true, "gpcEnabled": false]
        case "UPDATE_DOMAIN_STATUS":
            scheduleAppRefresh()
            
            guard let innerMessage else {
                response = [ "success": false ]
                break
            }
            var newQueueArray = meeExtensionQueue

            if let innerMessageDecoded = MeeExtenstionEntry.fromString(innerMessage) {
                newQueueArray = newQueueArray.filter { $0.domain != innerMessageDecoded.domain }
                let newValue = MeeExtenstionEntry(domain: innerMessageDecoded.domain, gpcEnabled: innerMessageDecoded.gpcEnabled, updated: Date().iso8601withFractionalSeconds)
                newQueueArray.append(newValue)
                extensionSharedDefaults?.set(encodeJson(newValue),forKey: newValue.domain)
            }

            extensionSharedDefaults?.set(encodeJson(newQueueArray),forKey: MEE_EXTENSION_QUEUE)
//            sendNotification()
            response = [ "success": true]
        default:
            response = [ "success": false, "error": "unsupportedQuery", "debug": "\(innerType) \(innerMessage) \(message)" ]
        }

        let responseItem = NSExtensionItem()
        responseItem.userInfo = [ SFExtensionMessageKey:  response]


        context.completeRequest(returningItems: [responseItem], completionHandler: nil)
    }

}

