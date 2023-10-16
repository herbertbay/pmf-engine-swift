//
//  PMFEngineManager.swift
//  pmf-engine-swift_Example
//
//  Created by Nataliia Kozlovska on 11.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import pmf_engine_swift

class PMFEngineManager {

  func configure() {
    let accountId = "earkick"
    let userId = UUID().uuidString
    PMFEngine.default.configure(accountId: accountId, userId: userId)
  }

  func showPopupWithViewIfNeeded(on viewController: UIViewController?) {
    let popupView = createPMFPopupView()
    DispatchQueue.main.async {
      PMFEngine.default.showPMFPopup(popupView: popupView, onViewController: viewController)
    }
  }

  func showPopupIfNeeded() {
    DispatchQueue.main.async {
      PMFEngine.default.showPMFPopup()
    }
  }

  private func createPMFPopupView() -> PMFEnginePopupView {
    let popupView = PMFEnginePopupView()

    popupView.emoji = UIImage(named: "smilling-panda")
    popupView.title = "Pleeeeease! 🙏\n Help us to improve \nto help others!"
    popupView.subTitle = "By answering a few simple questions."
    popupView.confirmTitle = "Yes, happy to help!"
    popupView.cancelTitle = "No, I don’t want to help!"

    popupView.containerBackgroundColor = UIColor.white
    popupView.closeButtonTitleColor = UIColor.lightGray
    popupView.pmfButtonBackgroundColor = UIColor.purple
    popupView.pmfButtonTitleColor = UIColor.white

    popupView.confirmFont = UIFont.systemFont(
      ofSize: 17,
      weight: .bold
    )

    popupView.cancelFont = UIFont.systemFont(
      ofSize: 14,
      weight: .semibold
    )

    return popupView
  }
}
