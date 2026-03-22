//
//  OnboardingViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/2/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import UIKit

/// Displays quick tips on how to use the app. Shown on first launch and accessible via nav bar info button.
class OnboardingViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.onboardingTitle
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.onboardingSubtitle
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .tertiaryLabel
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator.withAlphaComponent(0.5)
        return view
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: Constant.xmark_circle, withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.accessibilityLabel = AccessibilityLabels.dismissButtonLabel
        button.accessibilityHint = AccessibilityLabels.dismissButtonTipsHint
        return button
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let tips: [(icon: String, title: String, body: String)] = [
        (
            "percent",
            NSLocalizedString("Tip Percentages & Slider", comment: "Onboarding tip 1 title"),
            NSLocalizedString("Use the segment for quick percentages (10%, 15%, 20%, 25%). Double tap the total bill value to reveal a custom tip slider (0–30%).", comment: "Onboarding tip 1 body")
        ),
        (
            "person.2",
            NSLocalizedString("Split Bill Up to 10 People", comment: "Onboarding tip 2 title"),
            NSLocalizedString("Use the stepper below the split section to divide the bill among up to 10 people. Total per person updates automatically.", comment: "Onboarding tip 2 body")
        ),
        (
            "tag",
            NSLocalizedString("Category & Custom Subjects", comment: "Onboarding tip 3 title"),
            NSLocalizedString("Select a category (Restaurant, Bar, Delivery) or tap \"Custom\" to add your own tags for tracking bills by type.", comment: "Onboarding tip 3 body")
        ),
        (
            "chart.bar.doc.horizontal",
            NSLocalizedString("Insights View", comment: "Onboarding tip 4 title"),
            NSLocalizedString("Open Saved Bills and tap Insights to see your spending overview: total expenses, tips paid, and split bills across categories.", comment: "Onboarding tip 4 body")
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        setupUI()
    }

    private func setupUI() {
        view.addSubViews(topView, scrollView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        topView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            size: .init(width: 0, height: 76)
        )
        scrollView.anchor(
            top: topView.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            padding: .zero
        )

        topView.addSubViews(titleLabel, subtitleLabel, dismissButton, topSeparatorView)

        titleLabel.anchor(
            top: topView.topAnchor,
            left: topView.leftAnchor,
            bottom: nil,
            right: nil,
            padding: .init(top: 16, left: 20, bottom: 0, right: 0)
        )
        subtitleLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: topView.leftAnchor,
            bottom: nil,
            right: nil,
            padding: .init(top: 4, left: 20, bottom: 0, right: 0)
        )
        dismissButton.anchor(
            top: nil,
            left: nil,
            bottom: nil,
            right: topView.rightAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 16),
            size: .init(width: 44, height: 44)
        )
        dismissButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        topSeparatorView.anchor(
            top: nil,
            left: topView.leftAnchor,
            bottom: topView.bottomAnchor,
            right: topView.rightAnchor,
            padding: .zero,
            size: .init(width: 0, height: 1.0 / UIScreen.main.scale)
        )

        scrollView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.anchor(
            top: scrollView.contentLayoutGuide.topAnchor,
            left: scrollView.frameLayoutGuide.leftAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            right: scrollView.frameLayoutGuide.rightAnchor,
            padding: .init(top: 24, left: 20, bottom: 24, right: 20)
        )
        contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40).isActive = true

        for tip in tips {
            contentStackView.addArrangedSubview(makeTipCard(icon: tip.icon, title: tip.title, body: tip.body))
        }
    }

    private func makeTipCard(icon: String, title: String, body: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemTeal
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.alignment = .leading

        card.addSubViews(iconView, textStack)
        iconView.anchor(
            top: card.topAnchor,
            left: card.leftAnchor,
            bottom: nil,
            right: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 0),
            size: .init(width: 28, height: 28)
        )
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.anchor(
            top: card.topAnchor,
            left: iconView.rightAnchor,
            bottom: card.bottomAnchor,
            right: card.rightAnchor,
            padding: .init(top: 16, left: 12, bottom: 16, right: 16)
        )

        return card
    }

    @objc private func handleDismiss() {
        UserDefaults.standard.set(true, forKey: Constant.onboardingDismissedKey)
        dismiss(animated: true)
    }
}
