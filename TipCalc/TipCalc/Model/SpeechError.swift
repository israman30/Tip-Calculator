//
//  SpeechError.swift
//  TipCalc
//
//  Created by Israel Manzo on 4/22/26.
//  Copyright © 2026 Israel Manzo. All rights reserved.
//

import Foundation
import Speech

/// Error cases for Speech recognition operations
enum SpeechError: Error {
    case authorizationDenied
    case authorizationRestricted
    case authorizationNotDetermined
    case recognizerUnavailable
    case recognitionRequestFailed
    case audioSessionFailed(Error)
    case audioEngineStartFailed(Error)
    case recognitionTaskFailed(Error)
}

extension SpeechError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "Speech recognition access was denied."
        case .authorizationRestricted:
            return "Speech recognition is restricted on this device."
        case .authorizationNotDetermined:
            return "Speech recognition authorization has not been determined."
        case .recognizerUnavailable:
            return "Speech recognizer is not available for this locale."
        case .recognitionRequestFailed:
            return "Failed to create speech recognition request."
        case .audioSessionFailed(let error):
            return "Audio session error: \(error.localizedDescription)"
        case .audioEngineStartFailed(let error):
            return "Failed to start audio engine: \(error.localizedDescription)"
        case .recognitionTaskFailed(let error):
            return "Recognition failed: \(error.localizedDescription)"
        }
    }
}
