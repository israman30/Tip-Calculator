//
//  SpendingInsightsViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/1/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import UIKit
import SwiftUI

/// Displays spending insights: total spent, total tips, and average tip percentage
class SpendingInsightsViewController: UIViewController, SetupUIProtocol, SaveViewModelProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.spendingInsights
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.yourTipAndSpendingOverview
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .tertiaryLabel
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
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
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: Constant.xmark_circle, withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.accessibilityLabel = AccessibilityLabels.dismissButtonLabel
        button.accessibilityHint = AccessibilityLabels.dismissInsights
        return button
    }()

    var saveViewModel: SaveViewModel?
    private let insightsViewModel = SpendingInsightsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        refreshInsights()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveViewModel?.fetchItems()
        refreshInsights()
    }

    @objc private func handleDismiss() {
        dismiss(animated: true)
    }

    private func refreshInsights() {
        guard let bills = saveViewModel?.bills else { return }

        let totalWeek = insightsViewModel.totalSpentThisWeek(from: bills)
        let totalMonth = insightsViewModel.totalSpentThisMonth(from: bills)
        let tipsWeek = insightsViewModel.totalTipsThisWeek(from: bills)
        let tipsMonth = insightsViewModel.totalTipsThisMonth(from: bills)
        let avgTip = insightsViewModel.averageTipPercent(from: bills)

        updateCardViews(
            totalSpentWeek: totalWeek,
            totalSpentMonth: totalMonth,
            totalTipsWeek: tipsWeek,
            totalTipsMonth: tipsMonth,
            averageTipPercent: avgTip
        )
    }

    private func updateCardViews(
        totalSpentWeek: Double,
        totalSpentMonth: Double,
        totalTipsWeek: Double,
        totalTipsMonth: Double,
        averageTipPercent: Double
    ) {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        contentStackView.addArrangedSubview(createInsightCard(
            title: NSLocalizedString("Total Spent This Week", comment: ""),
            value: formatCurrency(totalSpentWeek),
            iconName: "calendar.badge.clock"
        ))
        contentStackView.addArrangedSubview(createInsightCard(
            title: NSLocalizedString("Total Spent This Month", comment: ""),
            value: formatCurrency(totalSpentMonth),
            iconName: "calendar"
        ))
        contentStackView.addArrangedSubview(createInsightCard(
            title: NSLocalizedString("Total Tips Given", comment: ""),
            subtitle: NSLocalizedString("Week / Month", comment: ""),
            value: "\(formatCurrency(totalTipsWeek)) / \(formatCurrency(totalTipsMonth))",
            iconName: "dollarsign.circle.fill"
        ))
        contentStackView.addArrangedSubview(createInsightCard(
            title: NSLocalizedString("Average Tip %", comment: ""),
            value: String(format: "%.1f%%", averageTipPercent),
            iconName: "percent"
        ))
    }

    private func createInsightCard(
        title: String,
        subtitle: String? = nil,
        value: String,
        iconName: String
    ) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.06

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let iconView = UIImageView(image: UIImage(systemName: iconName, withConfiguration: iconConfig))
        iconView.tintColor = .systemTeal
        iconView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontSizeToFitWidth = true

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, valueLabel])
        if let sub = subtitle, !sub.isEmpty {
            let subLabel = UILabel()
            subLabel.text = sub
            subLabel.font = .preferredFont(forTextStyle: .caption2)
            subLabel.textColor = .tertiaryLabel
            stack.insertArrangedSubview(subLabel, at: 2)
        }
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.anchor(
            top: container.topAnchor,
            left: container.leftAnchor,
            bottom: container.bottomAnchor,
            right: container.rightAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16)
        )
        iconView.anchor(top: nil, left: nil, bottom: nil, right: nil, size: .init(width: 32, height: 32))

        return container
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        view.addSubViews(topView, scrollView)
        scrollView.addSubview(contentStackView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

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
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        contentStackView.anchor(
            top: scrollView.topAnchor,
            left: scrollView.leftAnchor,
            bottom: scrollView.bottomAnchor,
            right: scrollView.rightAnchor,
            padding: .init(top: 16, left: 16, bottom: 24, right: 16)
        )
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true

        topView.addSubViews(titleLabel, subtitleLabel, dismissButton)

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
    }
}

// MARK: - SwiftUI Preview
extension SpendingInsightsViewController {
    static func makePreview() -> SpendingInsightsViewController {
        let vc = SpendingInsightsViewController()
        let vm = SaveViewModel()
        vm.bills = PresentingTipViewController.makeMockBills()
        vc.saveViewModel = vm
        return vc
    }
}

#Preview("Spending Insights") {
    UIViewControllerPreview {
        SpendingInsightsViewController.makePreview()
    }
}
