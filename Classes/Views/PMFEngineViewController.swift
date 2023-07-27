//
//  PMFEngineViewController.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 27.07.2023.
//

import Foundation

class CenterAlertBaseController<T>: UIViewController {
  var contentView: T!
}

final class PMFEngineViewController: CenterAlertBaseController<PMFEnginePopupView> {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupContentView()
    isModalInPresentation = true
  }

  init(contentView: PMFEnginePopupView?) {
    super.init(nibName: nil, bundle: nil)
    self.contentView = contentView
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setupContentView() {
    view.backgroundColor = .clear
    view.addSubview(contentView)

    contentView.setConstraints(equalTo: view)
  }
}
