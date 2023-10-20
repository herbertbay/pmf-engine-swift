//
//  WebContentView.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 19.10.2023.
//

import UIKit
import WebKit

class WebPageContentView: UIView, WKNavigationDelegate, WKUIDelegate {

  var backAction: (() -> Void)?

  var url: URL? {
    didSet {
      guard let url = url else {
        return
      }
      webView.load(URLRequest(url: url))
    }
  }

  var webViewBgColor: UIColor? {
    didSet {
      webView.backgroundColor = webViewBgColor
    }
  }

  private lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.scrollView.showsVerticalScrollIndicator = false
    return webView
  }()

  private let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .black
    return button
  }()

  init() {
    super.init(frame: .zero)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    configureUI()
  }

  private func configureUI() {
    addSubview(webView)
    addSubview(closeButton)

    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
      webView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      webView.leadingAnchor.constraint(equalTo: leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    closeButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
      closeButton.widthAnchor.constraint(equalToConstant: 44),
      closeButton.heightAnchor.constraint(equalToConstant: 44)
    ])

    closeButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
  }

  @objc private func backButtonPressed() {
    backAction?()
  }
}
