//
//  SpendingInsightsViewModel.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/1/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import Foundation
import CoreData

/// Provides spending insights computed from saved bills
final class SpendingInsightsViewModel {

    private lazy var dateFormatters: [DateFormatter] = {
        let formats = ["MMM d, yyyy 'at' h:mm a", "MMM d, yyyy", "MMM dd, yyyy 'at' h:mm a", "MMM dd, yyyy"]
        return formats.map { format in
            let df = DateFormatter()
            df.dateFormat = format
            df.locale = Locale(identifier: "en_US")
            return df
        }
    }()

    /// Parses a currency string (e.g. "$15.00 tip") to extract the numeric value
    private func parseCurrency(from string: String?) -> Double {
        guard let string = string, !string.isEmpty else { return 0 }
        let regex = try? NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
        let range = NSRange(string.startIndex..., in: string)
        guard range.location != NSNotFound else { return 0 }
        let cleaned = regex?.stringByReplacingMatches(
            in: string,
            options: [],
            range: range,
            withTemplate: ""
        ) ?? string
        return Double(cleaned) ?? 0
    }

    /// Parses the bill date string to a Date
    private func parseDate(from string: String?) -> Date? {
        guard let string = string else { return nil }
        for formatter in dateFormatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        return nil
    }

    /// Returns bills within the given rolling window (last week / last month).
    /// Uses start-of-day for the window boundary so date-only saved strings (e.g. `MMM d, yyyy`)
    /// are not excluded when they fall on the first calendar day of the window.
    private func bills(in period: Calendar.Component, value: Int, from bills: [Bill]) -> [Bill] {
        let calendar = Calendar.current
        guard let periodStart = calendar.date(byAdding: period, value: -value, to: Date()) else { return [] }
        let now = Date()
        let windowStart = calendar.startOfDay(for: periodStart)

        return bills.filter { bill in
            guard let date = parseDate(from: bill.date) else { return false }
            return date >= windowStart && date <= now
        }
    }

    // MARK: - Public Insights

    /// Total amount spent (bill total) this week
    func totalSpentThisWeek(from allBills: [Bill]) -> Double {
        bills(in: Calendar.Component.weekOfYear, value: 1, from: allBills)
            .map { parseCurrency(from: $0.total) }
            .reduce(0, +)
    }

    /// Total amount spent (bill total) this month
    func totalSpentThisMonth(from allBills: [Bill]) -> Double {
        bills(in: Calendar.Component.month, value: 1, from: allBills)
            .map { parseCurrency(from: $0.total) }
            .reduce(0, +)
    }

    /// Total tips given this week
    func totalTipsThisWeek(from allBills: [Bill]) -> Double {
        bills(in: Calendar.Component.weekOfYear, value: 1, from: allBills)
            .map { parseCurrency(from: $0.tip) }
            .reduce(0, +)
    }

    /// Total tips given this month
    func totalTipsThisMonth(from allBills: [Bill]) -> Double {
        bills(in: Calendar.Component.month, value: 1, from: allBills)
            .map { parseCurrency(from: $0.tip) }
            .reduce(0, +)
    }

    /// Average tip percentage across all bills (or filtered set)
    func averageTipPercent(from allBills: [Bill], inPeriod period: Calendar.Component? = nil, value: Int = 1) -> Double {
        var filtered = allBills
        if let period = period {
            filtered = bills(in: period, value: value, from: allBills)
        }

        var totalTip: Double = 0
        var totalBill: Double = 0

        for bill in filtered {
            let tip = parseCurrency(from: bill.tip)
            let input = parseCurrency(from: bill.input)
            if input > 0 {
                totalTip += tip
                totalBill += input
            }
        }

        guard totalBill > 0 else { return 0 }
        return (totalTip / totalBill) * 100
    }
}

