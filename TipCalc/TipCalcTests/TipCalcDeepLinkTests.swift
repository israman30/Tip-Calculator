//
//  TipCalcDeepLinkTests.swift
//  TipCalcTests
//

import XCTest
@testable import TipCalc

final class TipCalcDeepLinkTests: XCTestCase {

    func test_parseOpenURL_wrongScheme_returnsNil() {
        XCTAssertNil(TipCalcDeepLink.parseOpenURL(URL(string: "https://example.com/open")!))
    }

    func test_parseOpenURL_wrongHost_returnsNil() {
        XCTAssertNil(TipCalcDeepLink.parseOpenURL(URL(string: "tipcalc://calculate")!))
    }

    func test_parseOpenURL_schemeAndHostCaseInsensitive() {
        XCTAssertEqual(TipCalcDeepLink.parseOpenURL(URL(string: "TIPCALC://OPEN")!), .openOnly)
    }

    func test_parseOpenURL_noQuery_openOnly() {
        XCTAssertEqual(TipCalcDeepLink.parseOpenURL(URL(string: "tipcalc://open")!), .openOnly)
    }

    func test_parseOpenURL_percentQuery_parsesInteger() {
        XCTAssertEqual(TipCalcDeepLink.parseOpenURL(URL(string: "tipcalc://open?percent=15")!), .withTipPercentQuery(15))
    }

    func test_parseOpenURL_percentNotInteger_fallsBackToOpenOnly() {
        XCTAssertEqual(TipCalcDeepLink.parseOpenURL(URL(string: "tipcalc://open?percent=abc")!), .openOnly)
    }

    func test_parseOpenURL_arbitraryInteger_inQuery() {
        XCTAssertEqual(TipCalcDeepLink.parseOpenURL(URL(string: "tipcalc://open?percent=99")!), .withTipPercentQuery(99))
    }
}
