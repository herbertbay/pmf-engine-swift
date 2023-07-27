//
//  ViewController.swift
//  pmf-engine-swift
//
//  Created by Nataliia on 07/25/2023.
//  Copyright (c) 2023 Nataliia. All rights reserved.
//

import UIKit
import pmf_engine_swift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    PMFEngine.default.trackKeyEvent("eventName")
    PMFEngine.default.trackKeyEvent("eventName")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

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

//    PMFEngine.default.showPMFPopup(popupView: popupView, onViewController: self, forceShow: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

