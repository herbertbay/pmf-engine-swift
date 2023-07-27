//
//  UIViewController+Top.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 27.07.2023.
//

import UIKit

public extension UIViewController {
  var topController: UIViewController {
    return topViewController(from: self) ?? self
  }

  private func topViewController(from rootViewController: UIViewController?) -> UIViewController? {
    guard rootViewController != nil else { return nil }

    if let tabBarController = rootViewController as? UITabBarController {
      return topViewController(from: tabBarController.selectedViewController)

    } else if let navigationController = rootViewController as? UINavigationController {
      return topViewController(from: navigationController.visibleViewController)

    } else if let presentedController = rootViewController?.presentedViewController {
      return topViewController(from: presentedController)
    } else {
      return rootViewController
    }
  }
}
