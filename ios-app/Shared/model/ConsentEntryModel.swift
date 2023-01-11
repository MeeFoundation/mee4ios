//
//  ConsentItemModel.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 17.02.2022.
//

import Foundation

struct ConsentEntryModel: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: ConsentEntryType
    var value: String?
    var providedBy: String?
    var storageDuration: ConsentStorageDuration = .manualRemove
    var isRequired: Bool = false
    var canRead: Bool = true
    var canWrite: Bool = true
    var hasValue: Bool = true
    var isOn: Bool = false
    var forceOpen: Bool?
    var isOpen: Bool {
        get {
            if let forceOpen {
                return forceOpen
            } else {
                if let value {
                    return isRequired && (value.isEmpty)
                }
            }
            return false
        }
        set(newValue) {
            forceOpen = newValue
        }
    }
    var isIncorrect: Bool {
        return (isRequired || isOn) && (value == nil || value!.isEmpty)
    }
    private enum CodingKeys: String, CodingKey {
        case name, value, isRequired, providedBy, hasValue, type, storageDuration
    }
    init(name: String, type: ConsentEntryType, value: String?, providedBy: String?, isRequired: Bool? = false, canRead: Bool? = true, canWrite: Bool? = true, hasValue: Bool? = true, isOn: Bool? = false) {
        self.name = name
        self.type = type
        self.value = value
        self.providedBy = providedBy
        self.isRequired = isRequired ?? false
        self.canRead = canRead ?? true
        self.canWrite = canWrite ?? true
        self.hasValue = hasValue ?? true
        self.isOn = isOn ?? false
    }
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          if let name = try container.decodeIfPresent(String.self, forKey: .name) {
              self.name = name
          } else {
              self.name = ""
          }
          if let value = try container.decodeIfPresent(String.self, forKey: .value) {
              self.value = value
          }
          
          if let type = try container.decodeIfPresent(ConsentEntryType.self, forKey: .type) {
              self.type = type
          } else {
              self.type = ConsentEntryType.name
          }
          
          if let hasValue = try container.decodeIfPresent(Bool.self, forKey: .hasValue) {
              self.hasValue = hasValue
          } else {
              self.hasValue = true
          }
          
          if let providedBy = try container.decodeIfPresent(String.self, forKey: .providedBy) {
              self.providedBy = providedBy
          } else {
              self.providedBy = nil
          }
          
          if let storageDuration = try container.decodeIfPresent(ConsentStorageDuration.self, forKey: .storageDuration) {
              self.storageDuration = storageDuration
          } else {
              self.storageDuration = ConsentStorageDuration.manualRemove
          }
          
          if let isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired) {
              self.isRequired = isRequired
              if !isRequired {
                  self.isOn = true
              }
          }
      }
}
