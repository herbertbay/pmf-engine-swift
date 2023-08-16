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

// MARK: - PMFProtocol

public final class PMFEngine: PMFProtocol {

  public static let `default` = PMFEngine()

  internal var defaults: PMFUserDefaultsProtocol
  internal var pmfNetworkService: PMFNetworkProtocol

  typealias Action = () -> Void

  init(defaults: PMFUserDefaultsProtocol = PMFUserDefaults(),
       networkService: PMFNetworkProtocol = PMFNetworkService()) {
    self.defaults = defaults
    self.pmfNetworkService = networkService
  }

  public func configure(accountId: String, userId: String) {
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

  public func showPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    showFormPopupIfNeeded(forceShow: false, popupView: popupView, onViewController: onViewController)
  }

  public func forceShowPMFPopup(popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    showFormPopupIfNeeded(forceShow: true, popupView: popupView, onViewController: onViewController)
  }

  internal func showFormPopupIfNeeded(forceShow: Bool, popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    pmfNetworkService.getFormActions(forceShow: forceShow, accountId: accountId, userId: userId) { [weak self] commands in
      guard let command = commands?.first(where: { $0.type == "form" }), let url = URL(string: command.url) else { return }

      self?.showPopup(url: url, popupView: popupView, onViewController: onViewController)
    }
  }

  internal func showPopup(url: URL, popupView: PMFEnginePopupView, onViewController: UIViewController?) {
    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    let pmfAlertVC = PMFEngineViewController(
      contentView: popupView
    )

    let formShowingCompletion: Action = { [weak self] in
      self?.pmfNetworkService.trackFormShowing(accountId: accountId, userId: userId)
    }

    popupView.pressedShowButton = {
      UIApplication.shared.open(url, options: [:])
    }

    popupView.cancelCompletion = {
      pmfAlertVC.dismiss(animated: false)
    }

    pmfAlertVC.modalPresentationStyle = .overFullScreen
    onViewController?.present(pmfAlertVC, animated: false, completion: formShowingCompletion)
  }
}
