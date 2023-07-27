//
//  PMFUserDefaults.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import Foundation

internal protocol PMFUserDefaultsProtocol {
  var registeredDate: Date? { get set }
  var accountId: String? { get set }
  var userId: String? { get set }
  var keyActionsPerformedCount: [String: Int] { get set }
}

class PMFUserDefaults: PMFUserDefaultsProtocol {

  struct UserDefaultsKeys {
    static let userId = "userId"
    static let accountId = "accountId"
    static let registeredDate = "registeredDate"
    static let keyActionsPerformedCount = "keyActionsPerformedCount"
  }

  // MARK: - Private

  private var service = UserDefaults.standard

  // MARK: - Public

  var userId: String? {
    get {
      service.value(
        forKey: UserDefaultsKeys.userId
      ) as? String
    }
    set {
      service.setValue(
        newValue,
        forKey: UserDefaultsKeys.userId
      )
    }
  }

  var accountId: String? {
    get {
      service.value(
        forKey: UserDefaultsKeys.accountId
      ) as? String
    }
    set {
      service.setValue(
        newValue,
        forKey: UserDefaultsKeys.accountId
      )
    }
  }

  var registeredDate: Date? {
    get {
      service.value(
        forKey: UserDefaultsKeys.registeredDate
      ) as? Date
    }

    set {
      service.setValue(
        newValue,
        forKey: UserDefaultsKeys.registeredDate
      )
    }
  }

  var keyActionsPerformedCount: [String: Int] {
    get {
      service.value(
        forKey: UserDefaultsKeys.keyActionsPerformedCount
      ) as? [String: Int] ?? [:]
    }

    set {
      service.setValue(
        newValue,
        forKey: UserDefaultsKeys.keyActionsPerformedCount
      )
    }
  }
}
