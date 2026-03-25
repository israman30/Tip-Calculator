//
//  TipCalcDeepLink.swift
//  TipCalc
//
//  Parses widget / shortcut URLs: tipcalc://open[?percent=…]
//

import Foundation

enum TipCalcDeepLink {
    /// Result of parsing `tipcalc://open`.
    enum OpenKind: Equatable {
        case openOnly
        /// Present when `percent` query exists and is a valid integer (may still be ignored by the UI if not 10/15/20/25).
        case withTipPercentQuery(Int)
    }

    /// Returns `nil` unless the URL uses `Constant.deepLinkScheme` with host `open` (case-insensitive).
    static func parseOpenURL(_ url: URL) -> OpenKind? {
        guard url.scheme?.lowercased() == Constant.deepLinkScheme else { return nil }
        guard url.host?.lowercased() == "open" else { return nil }
        if let raw = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == "percent" })?
            .value,
            let percent = Int(raw) {
            return .withTipPercentQuery(percent)
        }
        return .openOnly
    }
}
