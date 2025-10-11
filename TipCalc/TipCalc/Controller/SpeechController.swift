//
//  SpeechController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import Speech

protocol SpeechControllerDelegate: AnyObject {
    func speechController(_ controller: SpeechController, didRecognizeText text: String)
    func speechControllerDidStartRecording(_ controller: SpeechController)
    func speechControllerDidStopRecording(_ controller: SpeechController)
}

class SpeechController {
    
    // MARK: - Properties
    weak var delegate: SpeechControllerDelegate?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - Initialization
    init() {
        requestSpeechAuthorization()
    }
    
    // MARK: - Public Methods
    
    /// Request authorization for speech recognition
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                // Authorization status will be handled by the delegate if needed
            }
        }
    }
    
    /// Check if speech recognition is authorized
    var isAuthorized: Bool {
        return SFSpeechRecognizer.authorizationStatus() == .authorized
    }
    
    /// Check if audio engine is currently running
    var isRecording: Bool {
        return audioEngine.isRunning
    }
    
    /// Start speech recognition/dictation
    func startDictation() {
        guard isAuthorized else {
            print("Speech recognition not authorized")
            return
        }
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session properties weren't set because of an error: \(error)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { return }
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.delegate?.speechController(self, didRecognizeText: recognizedText)
                }
            }
            
            if error != nil || (result?.isFinal ?? false) {
                DispatchQueue.main.async {
                    self.stopDictation()
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            delegate?.speechControllerDidStartRecording(self)
        } catch {
            print("audioEngine couldn't start because of an error: \(error)")
        }
    }
    
    /// Stop speech recognition/dictation
    func stopDictation() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        delegate?.speechControllerDidStopRecording(self)
    }
    
    /// Toggle between start and stop dictation
    func toggleDictation() {
        if isRecording {
            stopDictation()
        } else {
            startDictation()
        }
    }
}
