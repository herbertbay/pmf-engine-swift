//
//  WebViewController.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 19.10.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

  private var url: URL!
  private var bgColor: UIColor!
  private let contentView = WebPageContentView()

  convenience init(url: URL, bgColor: String?) {
    self.init(nibName: nil, bundle: nil)
    self.url = url
    self.bgColor = UIColor.hex(bgColor ?? "#FFFFFF")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupContentView()
  }

  private func setupContentView() {
    view.addSubview(contentView)
    view.backgroundColor = bgColor

    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    contentView.webViewBgColor = bgColor
    contentView.backAction = onBack
    contentView.url = url
  }

  private func onBack() {
    dismiss(animated: true)
  }
}
