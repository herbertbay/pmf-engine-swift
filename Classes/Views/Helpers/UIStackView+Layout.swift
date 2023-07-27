//
//  UIStackView+Layout.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 27.07.2023.
//

import UIKit

extension UIStackView {
  convenience init(
    arrangedViews: [UIView],
    axis: NSLayoutConstraint.Axis = .vertical,
    alignment: UIStackView.Alignment = .center,
    distribution: UIStackView.Distribution = .equalSpacing,
    spacing: CGFloat = 20.0
  ) {
    self.init(arrangedSubviews: arrangedViews)
    self.alignment = alignment
    self.axis = axis
    self.distribution = distribution
    self.spacing = spacing
    translatesAutoresizingMaskIntoConstraints = false
  }

  func setPadding(leading: CGFloat = 0, trailing: CGFloat = 0) {
    if leading > 0 {
      let leadingView = UIView()
      leadingView.translatesAutoresizingMaskIntoConstraints = false
      insertArrangedSubview(leadingView, at: 0)
      if axis == .horizontal {
        leadingView.setConstraints(width: leading)
      } else {
        leadingView.setConstraints(height: leading)
      }
      setCustomSpacing(0, after: leadingView)
    }

    if trailing > 0 {
      let traliningView = UIView()
      traliningView.translatesAutoresizingMaskIntoConstraints = false
      addArrangedSubview(traliningView)
      if axis == .horizontal {
        traliningView.setConstraints(width: trailing)
      } else {
        traliningView.setConstraints(height: trailing)
      }
      setCustomSpacing(0, after: traliningView)
    }
  }
}
