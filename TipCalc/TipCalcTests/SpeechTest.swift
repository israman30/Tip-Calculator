//
//  SpeechTest.swift
//  TipCalcTests
//
//  Created by Israel Manzo on 10/10/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//

import XCTest
@testable import TipCalc
import Speech
import AVFoundation

// MARK: - Mock Dependencies
class MockSpeechController: SpeechControllerProtocol {
    private(set) var didRequestAuthorization = false
    private(set) var didStartDictation = false
    private(set) var didStopDictation = false
    var simulateAuthorized: Bool = true
    var onStartDictation: (() -> Void)?
    var onStopDictation: (() -> Void)?
    
    func requestSpeechAuthorization() {
        didRequestAuthorization = true
        // You could simulate async behavior if needed
        if simulateAuthorized {
            print("✅ Mock: Speech authorization granted")
        } else {
            print("❌ Mock: Speech authorization denied")
        }
    }
    
    func startDictation() {
        didStartDictation = true
        print("🎤 Mock: Dictation started")
        onStartDictation?()
    }
    
    func stopDictation() {
        didStopDictation = true
        print("🛑 Mock: Dictation stopped")
        onStopDictation?()
    }
    
}

class MockTask: SFSpeechRecognitionTask {
    var canceled = false
    override func cancel() {
        canceled = true
    }
}

class MockAudioEngine: AVAudioEngine {
    var started = false
    var stopped = false
    override func start() throws {
        started = true
    }
    override func stop() {
        stopped = true
    }
}

final class SpeechTest: XCTestCase {
    
    var mock: MockSpeechController!
    var mockTask: MockTask!
    var engine: MockAudioEngine!
    
    override func setUpWithError() throws {
        mock = MockSpeechController()
        mockTask = MockTask()
        engine = MockAudioEngine()
    }
    
    override func tearDownWithError() throws {
        mock = nil
        mockTask = nil
        engine = nil
    }
    
    func test_startDictation_called() {
        mock.startDictation()
        XCTAssertTrue(mock.didStartDictation, "startDictation() should set didStartDictation to true")
    }
    
    func test_stopDictation_called() {
        mock.stopDictation()
        XCTAssertTrue(mock.didStopDictation, "stopDictation() should set didStopDictation to true")
    }
    
    func test_requestAuthorization_called() {
        mock.requestSpeechAuthorization()
        XCTAssertTrue(mock.didRequestAuthorization, "requestSpeechAuthorization() should set didRequestAuthorization to true")
    }
    
    func test_MockTask_cancel_setsCanceledTrue() {
        mockTask.cancel()
        XCTAssertTrue(mockTask.canceled, "Calling cancel() should set canceled = true")
    }
    
    func test_MockAudioEngine_start_setsStartedTrue() throws {
        try engine.start()
        XCTAssertTrue(engine.started, "Calling start() should set started = true")
        XCTAssertFalse(engine.stopped, "Engine should not be stopped immediately after start()")
    }
    
    func test_MockAudioEngine_stop_setsStoppedTrue() {
        engine.stop()
        XCTAssertTrue(engine.stopped, "Calling stop() should set stopped = true")
    }
    
    func test_MockAudioEngine_startAndStop_sequence() throws {
        try engine.start()
        engine.stop()
        XCTAssertTrue(engine.started, "Engine should have been started")
        XCTAssertTrue(engine.stopped, "Engine should have been stopped after stop()")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
