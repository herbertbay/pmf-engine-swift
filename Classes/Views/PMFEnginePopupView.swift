//
//  PMFEnginePopupView.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 27.07.2023.
//

import UIKit

// MARK: - PMFEnginePopupView

public class PMFEnginePopupView: UIView {
  var pressedShowButton: (() -> Void)?
  var cancelCompletion: (() -> Void)?

  // MARK: - Public

  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }

  public var subTitle: String? {
    didSet {
      subtitleLabel.text = subTitle
    }
  }

  public var emoji: UIImage? {
    didSet {
      emojiImage.image = emoji
      emojiImage.isHidden = emoji == nil
    }
  }

  public var confirmTitle: String? {
    didSet {
      showPMFButton.accessibilityLabel = confirmTitle
      showPMFButton.setTitle(confirmTitle, for: .normal)
    }
  }

  public var cancelTitle: String? {
    didSet {
      leaveButton.accessibilityLabel = cancelTitle
      leaveButton.setTitle(cancelTitle, for: .normal)
    }
  }

  public var confirmFont: UIFont = .systemFont(ofSize: 17) {
    didSet {
      showPMFButton.titleLabel?.font = confirmFont
    }
  }

  public var cancelFont: UIFont = .systemFont(ofSize: 17) {
    didSet {
      leaveButton.titleLabel?.font = cancelFont
    }
  }

  public var pmfButtonTitleColor: UIColor? {
    didSet {
      showPMFButton.setTitleColor(pmfButtonTitleColor, for: .normal)
    }
  }

  public var pmfButtonBackgroundColor: UIColor? {
    didSet {
      showPMFButton.backgroundColor = pmfButtonBackgroundColor
    }
  }

  public var closeButtonTitleColor: UIColor? {
    didSet {
      leaveButton.setTitleColor(closeButtonTitleColor, for: .normal)
    }
  }

  public var containerBackgroundColor: UIColor? {
    didSet {
      containerView.backgroundColor = containerBackgroundColor
    }
  }

  // MARK: - Private

  private let emojiImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = .label

    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = UIColor.black

    return label
  }()

  private let showPMFButton: UIButton = {
    let color = UIColor.purple
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = color
    button.setTitleColor(.white, for: .normal)
    button.tintColor = color
    button.titleLabel?.font = UIFont.systemFont(
      ofSize: 20,
      weight: .bold
    )
    button.accessibilityIdentifier = "continue"
    return button
  }()

  private let leaveButton: UIButton = {
    let color = UIColor.purple
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .clear
    button.setTitleColor(color, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(
      ofSize: 20,
      weight: .bold
    )
    button.accessibilityIdentifier = "leave"
    return button
  }()

  private var containerView = UIView()
  private var stackView = UIStackView()
  private var imageSizeConstraint: NSLayoutConstraint?

  private var leadingSubtitleConstraint: NSLayoutConstraint?
  private var trailingSubtitleConstraint: NSLayoutConstraint?

  // Internal methods

  open override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    showPMFButton.cornerRadiusPercentage = 50
  }

  // MARK: - Init

  convenience init() {
    self.init(frame: CGRect.zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func commonInit() {
    backgroundColor = UIColor.black.withAlphaComponent(0.5)

    stackView = UIStackView(
      arrangedViews: [
        emojiImage,
        titleLabel,
        subtitleLabel,
        showPMFButton,
        leaveButton
      ],
      alignment: .center,
      distribution: .fill,
      spacing: 18
    )

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(stackView)

    stackView.setConstraints(toView: containerView, top: 20, bottom: 0)
    leadingSubtitleConstraint = stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
    leadingSubtitleConstraint?.isActive = true
    trailingSubtitleConstraint = stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
    trailingSubtitleConstraint?.isActive = true

    containerView.backgroundColor = UIColor.white
    containerView.layer.cornerRadius = 10
    containerView.clipsToBounds = true
    addSubview(containerView)

    containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16).isActive = true
    let widthConstraint = containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 343)
    widthConstraint.priority = .defaultLow
    widthConstraint.isActive = true

    stackView.setCustomSpacing(32, after: subtitleLabel)
    stackView.setCustomSpacing(8, after: showPMFButton)

    showPMFButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
    showPMFButton.heightAnchor.constraint(equalToConstant: 38).isActive = true

    leaveButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 211).isActive = true

    imageSizeConstraint = emojiImage.heightAnchor.constraint(equalToConstant: 108)
    imageSizeConstraint?.isActive = true

    emojiImage.widthAnchor.constraint(equalTo: emojiImage.heightAnchor).isActive = true

    leaveButton.setConstraints(height: 38)
    stackView.setPadding(leading: 16, trailing: 16)

    accessibilityElements = [
      emojiImage,
      titleLabel,
      subtitleLabel,
      showPMFButton,
      leaveButton
    ]

    setupActions()
  }

  private func setupActions() {
    showPMFButton.addTarget(
      self,
      action: #selector(didTapContinueButton),
      for: .touchUpInside
    )
    leaveButton.addTarget(
      self,
      action: #selector(didTapLeaveButton),
      for: .touchUpInside
    )
  }

  // Actions

  @objc private func didTapContinueButton() {
    pressedShowButton?()
  }

  @objc private func didTapLeaveButton() {
    cancelCompletion?()
  }
}
