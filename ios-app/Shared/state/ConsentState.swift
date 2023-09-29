//
//  ConsentState.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 10.03.2022.
//

import Foundation


class ConsentState: ObservableObject {
    @Published var consent: MeeConsentRequest = MeeConsentRequest()

}

class AgentState: ObservableObject {
    @Published var agent: MeeAgentStore?

}

