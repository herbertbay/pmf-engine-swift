//
//  PMFEngine.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import UIKit

// MARK: - PMFProtocol

public protocol PMFProtocol {
  func configure(accountId: String, userId: String)
  func trackKeyEvent(_ name: String)
  func showPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?)
  func forceShowPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?)
}

// MARK: - PMFEngineExtendedProtocol

internal protocol PMFEngineExtendedProtocol: PMFProtocol {
  func hasAtLeastTwoKeyEvents() -> Bool
  func shouldShowPMFForm() -> Bool
  func buildPMFUrl() -> URL?
}

// MARK: - PMFEngineExtendedProtocol

public final class PMFEngine: PMFEngineExtendedProtocol {

  public static let `default` = PMFEngine()

  internal var defaults: PMFUserDefaultsProtocol = PMFUserDefaults()
  internal let pmfNetworkService = PMFNetworkService()

  init(defaults: PMFUserDefaultsProtocol = PMFUserDefaults()) {
    self.defaults = defaults
  }

  public func configure(accountId: String, userId: String) {
    defaults.registeredDate = Date()
    defaults.accountId = accountId
    defaults.userId = userId
  }

  public func trackKeyEvent(_ name: String) {
    var newActions = defaults.keyActionsPerformedCount

    if let count = newActions[name] {
      newActions[name] = count + 1
    } else {
      newActions[name] = 1
    }

    defaults.keyActionsPerformedCount = newActions

    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    pmfNetworkService.trackEvent(accountId: accountId, userId: userId, eventName: name)
  }

  public func buildPMFUrl() -> URL? {
    guard let accountId = defaults.accountId, let userId = defaults.userId else { return nil }
    let url = "https://pmf-engine.com/form/\(accountId)/feedback/:\(userId)/:iOS"
    return URL(string: url)
  }

  public func showPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    guard let url = buildPMFUrl(), shouldShowPMFForm() else { return }

    showPopup(url: url, popupView: popupView, onViewController: onViewController)
  }

  public func forceShowPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    guard let url = buildPMFUrl() else { return }

    showPopup(url: url, popupView: popupView, onViewController: onViewController)
  }

  internal func shouldShowPMFForm() -> Bool {
    guard let registeredDate = defaults.registeredDate else {
      return false
    }

    let twoWeeksAgoDate = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
    let isDateAfterTwoWeeks = registeredDate < twoWeeksAgoDate

    return hasAtLeastTwoKeyEvents() && isDateAfterTwoWeeks
  }

  internal func hasAtLeastTwoKeyEvents() -> Bool {
    defaults.keyActionsPerformedCount.values.reduce(0, +) > 2
  }

  internal func showPopup(url: URL, popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    let pmfAlertVC = PMFEngineViewController(
      contentView: popupView
    )

    popupView.pressedShowButton = {
      UIApplication.shared.open(url, options: [:])
    }

    popupView.cancelCompletion = {
      pmfAlertVC.dismiss(animated: false)
    }

    pmfAlertVC.modalPresentationStyle = .overFullScreen
    onViewController?.present(pmfAlertVC, animated: false)
  }
}
