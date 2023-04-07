//
//  ConsentDurationOptions.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.11.22..
//

let consentDurationOptions: [ConsentDurationOption] = [
    ConsentDurationOption(name: "While using app", description: "Shared with provider’s app during usage;\ndeleted by provider afterwards", value: .whileUsingApp),
    ConsentDurationOption(name: "Until connection deletion", description: "Shared with provider’s app until connection\nis deleted; removed by provider afterwards", value: .untilConnectionDeletion)
]
