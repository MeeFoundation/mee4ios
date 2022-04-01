//
//  CredentialProviderViewController.swift
//  Mee Credential Provider
//
//  Created by Anthony Ivanov on 28.03.2022.
//

import AuthenticationServices
import SwiftUI

struct UnlockScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    var extensionContext: ASCredentialProviderExtensionContext
    var credentials: ASPasswordCredential
    private func onUnlock(success: Bool) {
        if (success) {
            self.extensionContext.completeRequest(withSelectedCredential: credentials)
        }
        presentationMode.wrappedValue.dismiss()
    }
    private func onTryUnlock() {
        requestLocalAuthentication(onUnlock)
    }
//    init(extensionContext: ASCredentialProviderExtensionContext, credentials: ASPasswordCredential) {
//        self.extensionContext = extensionContext
//        self.credentials = credentials
//        onTryUnlock()
//    }
    var body: some View {
        VStack {
            Spacer()
            MainButton("Unlock", action: {
                onTryUnlock()
            }, image: Image(systemName: "key"), fullWidth: true)
            Spacer()
            DestructiveButton("Cancel", action: {
                presentationMode.wrappedValue.dismiss()
                extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
            }).padding(.bottom, 25)
        }.padding()
        
    }
}

struct AutofillView: View {
    let services: [String]
    var extensionContext: ASCredentialProviderExtensionContext
    let keychainItems: [PasswordEntryModel]
    @State var showAll = false

    var body: some View {
        VStack {
            Switch(isOn: $showAll, title: "Show all").padding(.bottom, 10)
            ScrollView {
                ForEach (keychainItems) { entry in
                    if showAll || services.contains(entry.url?.lowercased() ?? "") {
                        ListButton(entry.name ?? "", entry.username ?? "", entry.url ?? "") {
                            self.extensionContext.completeRequest(withSelectedCredential: ASPasswordCredential(user: entry.username ?? "", password: entry.password ?? ""))
                        }
                    }
                    
                }
            }
            Spacer()
            DestructiveButton("Cancel", action: {
                extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
            })
        }
        .padding()
        .padding(.bottom, 30)
    }
}

class CredentialProviderViewController: ASCredentialProviderViewController {
    let store = ASCredentialIdentityStore.shared
    var keychain = KeyChain()
    
    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        let services: [String] = serviceIdentifiers.map { $0.identifier }
        let keychainItems = keychain.getAllItems()
        var entries: [PasswordEntryModel] = []
        for (_, keychainItem) in keychainItems {
            entries.append(keychainItem)
        }
        
        let autofillPasswordListView = AutofillView(services: services, extensionContext: self.extensionContext,
                                                    keychainItems: entries)
                
        let vc = UIHostingController(rootView: autofillPasswordListView)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.frame = view.bounds
                
        view.addSubview(vc.view)
        addChild(vc)
    }


//     Implement this method if your extension supports showing credentials in the QuickType bar.
//     When the user selects a credential from your app, this method will be called with the
//     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
//     Provide the password by completing the extension request with the associated ASPasswordCredential.
//     If using the credential would require showing custom UI for authenticating the user, cancel
//     the request with error code ASExtensionError.userInteractionRequired.

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
//        let databaseIsUnlocked = false
//        if (databaseIsUnlocked) {
            let entry = self.keychain.getItemByName(name: credentialIdentity.recordIdentifier!)
            if entry == nil {return}
            let credentials = ASPasswordCredential(user: entry!.username ?? "", password: entry!.password ?? "")
            self.extensionContext.completeRequest(withSelectedCredential: credentials)
//        } else {
//            self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code:ASExtensionError.userInteractionRequired.rawValue))
//        }
    }
    
    

//     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
//     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
//     UI and call this method. Show appropriate UI for authenticating the user then provide the password
//     by completing the extension request with the associated ASPasswordCredential.

    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
        let entry = self.keychain.getItemByName(name: credentialIdentity.recordIdentifier!)
        if entry == nil {return}
        let credentials = ASPasswordCredential(user: entry!.username ?? "", password: entry!.password ?? "")
        let unlockScreen = UnlockScreenView(extensionContext: self.extensionContext, credentials: credentials)
        let vc = UIHostingController(rootView: unlockScreen)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.frame = view.bounds
                
        view.addSubview(vc.view)
        addChild(vc)
    }
    
    override func prepareInterfaceForExtensionConfiguration() {
        self.keychain.updateCredentialStore()
    }


}
