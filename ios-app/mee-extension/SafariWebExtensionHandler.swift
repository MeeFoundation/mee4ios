//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Roman Siliuk on 29.03.23.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message"
let SFExtensionMessageTypeKey = "type"

let extensionSharedDefaults = UserDefaults(suiteName: "group.extensionshare.foundation.mee.ios-client")

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        guard let item = context.inputItems[0] as? NSExtensionItem else {
            return
        }
        let message = item.userInfo?[SFExtensionMessageKey] as? [String: String]
        
        let innerMessage = message?[SFExtensionMessageKey] as? String
        let innerType = message?[SFExtensionMessageTypeKey] as? String
        
        var response: [String : Any]
        switch(innerType) {
        case "GET_DOMAIN_STATUS":
            guard let innerMessage else {
                response = ["hasConnection" : false]
                break
            }
            let hasConnection = extensionSharedDefaults?.bool(forKey: innerMessage)
            
            response = ["hasConnection" : hasConnection == true]
        default:
            response = [ "error": "unsupportedQuery: \(innerType) \(innerMessage)" ]
        }

        let responseItem = NSExtensionItem()
        responseItem.userInfo = [ SFExtensionMessageKey:  response]


        context.completeRequest(returningItems: [responseItem], completionHandler: nil)
    }

}
