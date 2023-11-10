//
//  PMFEngine.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import UIKit
import WebKit

// MARK: - PMFProtocol

public protocol PMFProtocol {
  func configure(accountId: String, userId: String)
  func trackKeyEvent(_ name: String)
  func showPMFPopup(for eventName: String?, popupView: PMFEnginePopupView?, onViewController: UIViewController?)
}

public extension PMFProtocol {
  func trackKeyEvent(_ name: String? = nil) {
    trackKeyEvent("")
  }

  func showPMFPopup(for eventName: String? = nil, popupView: PMFEnginePopupView? = nil, onViewController: UIViewController? = nil) {
    showPMFPopup(for: eventName, popupView: popupView, onViewController: onViewController)
  }
}

// MARK: - PMFProtocol

public final class PMFEngine: NSObject, PMFProtocol {

  public static let `default` = PMFEngine()

  internal var defaults: PMFUserDefaultsProtocol
  internal var pmfNetworkService: PMFNetworkProtocol
  internal var openController: Action?

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
    let eventName = name.isEmpty ? "default" : name
    var newActions = defaults.keyActionsPerformedCount

    if let count = newActions[eventName] {
      newActions[eventName] = count + 1
    } else {
      newActions[eventName] = 1
    }

    defaults.keyActionsPerformedCount = newActions

    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    pmfNetworkService.trackEvent(accountId: accountId, userId: userId, eventName: name)
  }

  public func showPMFPopup(for eventName: String?, popupView: PMFEnginePopupView?, onViewController: UIViewController?) {
    showFormPopupIfNeeded(for: eventName, popupView: popupView, onViewController: onViewController)
  }

  internal func showFormPopupIfNeeded(for eventName: String?, popupView: PMFEnginePopupView?, onViewController: UIViewController?) {
    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    pmfNetworkService.getFormActions(accountId: accountId, userId: userId, for: eventName) { [weak self] commands in
      guard let command = commands?.first(where: { $0.type == "form" }), let url = URL(string: command.url) else { return }
      self?.showPopup(url: url, popupView: popupView, bgColor: command.formData?.colors?.background, onViewController: onViewController)
    }
  }

  internal func showPopup(url: URL, popupView: PMFEnginePopupView?, bgColor: String?, onViewController: UIViewController?) {
    guard let accountId = defaults.accountId, let userId = defaults.userId else { return }

    let viewController = onViewController ?? UIApplication.shared.windows.first?.rootViewController

    guard let popupView = popupView else {
      showWebController(withURL: url, bgColor: bgColor, viewController: viewController)
      return
    }

    let pmfAlertVC = PMFEngineViewController(
      contentView: popupView
    )

    let formShowingCompletion: Action = { [weak self] in
      self?.pmfNetworkService.trackFormShowing(accountId: accountId, userId: userId)
    }

    popupView.pressedShowButton = { [weak self] in
      self?.showWebController(withURL: url, bgColor: bgColor, viewController: pmfAlertVC)
    }

    popupView.cancelCompletion = {
      pmfAlertVC.dismiss(animated: false)
    }

    pmfAlertVC.modalPresentationStyle = .overFullScreen

    viewController?.present(pmfAlertVC, animated: false, completion: formShowingCompletion)
  }

  internal func showWebController(withURL url: URL, bgColor: String?, viewController: UIViewController?) {
    let webView = WKWebView(frame: .zero)
    let request = URLRequest(url: url)
    let webViewTag = 123

    webView.navigationDelegate = self
    webView.load(request)
    webView.tag = webViewTag
    viewController?.view.addSubview(webView)

    openController = {
      let webPageViewController = WebViewController(webView: webView, bgColor: bgColor)
      viewController?.view.subviews.filter { $0.tag == webViewTag }.forEach { $0.removeFromSuperview() }
      viewController?.present(webPageViewController, animated: true, completion: nil)
    }
  }
}

// MARK: - WKNavigationDelegate

extension PMFEngine: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.openController?()
    }
  }
}
