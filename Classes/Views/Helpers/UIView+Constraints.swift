//
//  UIView+Constraints.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 27.07.2023.
//

import UIKit

extension UIView {
  convenience init(
    containerFor subviews: [UIView],
    padding: CGFloat = 0
  ) {
    self.init(
      containerFor: subviews,
      top: padding,
      bottom: padding,
      leading: padding,
      trailing: padding
    )
  }

  convenience init(
    containerFor subviews: [UIView],
    top: CGFloat = 0,
    bottom: CGFloat = 0,
    leading: CGFloat = 0,
    trailing: CGFloat = 0
  ) {
    self.init()
    translatesAutoresizingMaskIntoConstraints = false
    subviews.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setConstraints(
        equalTo: self,
        top: top,
        bottom: bottom,
        leading: leading,
        trailing: trailing
      )
    }
  }

  convenience init(
    group subviews: [UIView]
  ) {
    self.init()
    translatesAutoresizingMaskIntoConstraints = false
    subviews.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }

  func setConstraintsToSuperView(
    top: CGFloat = 0,
    bottom: CGFloat = 0,
    leading: CGFloat = 0,
    trailing: CGFloat = 0
  ) {
    guard let superview = superview else {
      return
    }
    setConstraints(
      equalTo: superview,
      top: top,
      bottom: bottom,
      leading: leading,
      trailing: trailing
    )
  }

  func setConstraints(
    equalTo view: UIView,
    top: CGFloat = 0,
    bottom: CGFloat = 0,
    leading: CGFloat = 0,
    trailing: CGFloat = 0,
    height _: CGFloat = 0,
    heightConstanct _: CGFloat = 0,
    heightMultiplier _: CGFloat = 1,
    width _: CGFloat = 0,
    widthConstanct _: CGFloat = 0,
    widthMultiplier _: CGFloat = 1
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: top
      ),
      bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -bottom
      ),
      leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: leading
      ),
      trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -trailing
      )
    ])
  }

  func setConstraints(
    _ attributes: [NSLayoutConstraint.Attribute],
    equalTo view: UIView,
    widthConstant: CGFloat = 0,
    widthMultiplier: CGFloat = 1,
    widthRelation: NSLayoutConstraint.Relation = .equal,
    heightConstant: CGFloat = 0,
    heightMultiplier: CGFloat = 1,
    heightRelation: NSLayoutConstraint.Relation = .equal
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    if attributes.contains(.width) {
      NSLayoutConstraint(
        item: self,
        attribute: .width,
        relatedBy: widthRelation,
        toItem: view,
        attribute: .width,
        multiplier: widthMultiplier,
        constant: widthConstant
      ).isActive = true
    }
    if attributes.contains(.height) {
      NSLayoutConstraint(
        item: self,
        attribute: .height,
        relatedBy: heightRelation,
        toItem: view,
        attribute: .height,
        multiplier: heightMultiplier,
        constant: heightConstant
      ).isActive = true
    }
  }

  func setConstraintsEqual(
    toLayout layout: UILayoutGuide
  ) {
    setConstraints(
      toLayout: layout,
      top: 0,
      bottom: 0,
      leading: 0,
      trailing: 0
    )
  }

  func setConstraints(
    toView view: UIView,
    top: CGFloat? = nil,
    topPriority: UILayoutPriority = .required,
    bottom: CGFloat? = nil,
    bottomPriority: UILayoutPriority = .required,
    leading: CGFloat? = nil,
    leadingPriority: UILayoutPriority = .required,
    trailing: CGFloat? = nil,
    trailingPriority: UILayoutPriority = .required,
    centerX: CGFloat? = nil,
    centerXPriority: UILayoutPriority = .required,
    centerY: CGFloat? = nil,
    centerYPriority: UILayoutPriority = .required
  ) {
    setConstraints(
      toLayout: view.safeAreaLayoutGuide,
      top: top,
      topPriority: topPriority,
      bottom: bottom,
      bottomPriority: bottomPriority,
      leading: leading,
      leadingPriority: leadingPriority,
      trailing: trailing,
      trailingPriority: trailingPriority,
      centerX: centerX,
      centerXPriority: centerXPriority,
      centerY: centerY,
      centerYPriority: centerYPriority
    )
  }

  func setConstraints(
    toLayout layout: UILayoutGuide,
    top: CGFloat? = nil,
    topPriority: UILayoutPriority = .required,
    bottom: CGFloat? = nil,
    bottomPriority: UILayoutPriority = .required,
    leading: CGFloat? = nil,
    leadingPriority: UILayoutPriority = .required,
    trailing: CGFloat? = nil,
    trailingPriority: UILayoutPriority = .required,
    centerX: CGFloat? = nil,
    centerXPriority: UILayoutPriority = .required,
    centerY: CGFloat? = nil,
    centerYPriority: UILayoutPriority = .required
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    var constraints = [NSLayoutConstraint?]()
    constraints.append(
      createContraint(
        constant: top,
        from: topAnchor,
        to: layout.topAnchor,
        priority: topPriority
      )
    )
    constraints.append(
      createContraint(
        constant: bottom,
        from: bottomAnchor,
        to: layout.bottomAnchor,
        priority: bottomPriority
      )
    )
    constraints.append(
      createContraint(
        constant: leading,
        from: leadingAnchor,
        to: layout.leadingAnchor,
        priority: leadingPriority
      )
    )
    constraints.append(
      createContraint(
        constant: trailing,
        from: trailingAnchor,
        to: layout.trailingAnchor,
        priority: trailingPriority
      )
    )
    constraints.append(
      createContraint(
        constant: centerX,
        from: centerXAnchor,
        to: layout.centerXAnchor,
        priority: centerXPriority
      )
    )
    constraints.append(
      createContraint(
        constant: centerY,
        from: centerYAnchor,
        to: layout.centerYAnchor,
        priority: centerYPriority
      )
    )
    NSLayoutConstraint.activate(
      constraints.compactMap { $0 }
    )
  }

  func setConstraints(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    priority: UILayoutPriority = .required
  ) {
    var constraints = [NSLayoutConstraint?]()
    constraints.append(
      createContraint(
        constant: height,
        from: heightAnchor,
        priority: priority
      )
    )
    constraints.append(
      createContraint(
        constant: width,
        from: widthAnchor,
        priority: priority
      )
    )
  }

  func setMinSizeConstraints(
    priority: UILayoutPriority = .required
  ) {
    setConstraints(width: 64, height: 44, priority: priority)
  }

  func createContraint<T: AnyObject>(
    constant: CGFloat?,
    from: NSLayoutAnchor<T>,
    to: NSLayoutAnchor<T>,
    priority: UILayoutPriority
  ) -> NSLayoutConstraint? {
    translatesAutoresizingMaskIntoConstraints = false
    guard let constant = constant else {
      return nil
    }
    let constraint = from.constraint(equalTo: to, constant: constant)
    constraint.priority = priority
    constraint.isActive = true
    return constraint
  }

  func createContraint(
    constant: CGFloat?,
    from: NSLayoutDimension,
    priority: UILayoutPriority
  ) -> NSLayoutConstraint? {
    guard let constant = constant else {
      return nil
    }
    translatesAutoresizingMaskIntoConstraints = false
    let constraint = from.constraint(equalToConstant: constant)
    constraint.priority = priority
    constraint.isActive = true
    return constraint
  }
}

extension UIView {
  @discardableResult
  func setConstraintsBelow(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: const,
      from: topAnchor,
      to: view.bottomAnchor,
      priority: priority
    )!
  }

  @discardableResult
  func setConstraintsAbove(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: -const,
      from: bottomAnchor,
      to: view.topAnchor,
      priority: priority
    )!
  }

  @discardableResult
  func setConstraintsLeft(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: const,
      from: trailingAnchor,
      to: view.leadingAnchor,
      priority: priority
    )!
  }

  @discardableResult
  func setConstraintsRight(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: const,
      from: leadingAnchor,
      to: view.trailingAnchor,
      priority: priority
    )!
  }

  @discardableResult
  func setConstraintsHorizontallyAligned(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: const,
      from: centerXAnchor,
      to: view.centerXAnchor,
      priority: priority
    )!
  }

  @discardableResult
  func setConstraintsVerticallyAligned(
    _ view: UIView,
    const: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    return createContraint(
      constant: const,
      from: centerYAnchor,
      to: view.centerYAnchor,
      priority: priority
    )!
  }
}

// MARK: - Corner Radius

extension UIView {
  @IBInspectable
  var cornerRadiusPercentage: CGFloat {
    get {
      return layer.cornerRadius
    }

    set {
      layer.cornerRadius = frame.size.height * (newValue / 100)
    }
  }
}
