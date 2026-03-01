//
//  MainController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import SwiftUI
import Speech

/**
 - TIP CALCULATOR USES CORE DATA  API AS DATABASE
 - USING SWIFTUI API TO PREVIEW APP VIEW
 */
protocol CalculationsViewModelProtocol {
    var calculationsViewModel: CalculationsViewModel? { get set }
}

protocol SaveViewModelProtocol {
    var saveViewModel: SaveViewModel? { get set }
}

protocol TableViewProtocol {
    var tableView: UITableView { get }
}

protocol SpeechControllerProtocol {
    func requestSpeechAuthorization()
    func startDictation()
    func stopDictation()
}

class MainController: UIViewController, SetUIProtocol, CalculationsViewModelProtocol, SaveViewModelProtocol {
    
    let toastMessage = UIHostingController(rootView: ToastMessage())
    
    // MARK: - Primary input field for bill amount with real-time calculation updates
    // This text field triggers tip and total calculations as the user types
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: LocalizedString.textField_placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray3
            ]
        )
        tf.accessibilityHint = LocalizedString.textField_hint
        tf.setDynamicFont(font: .preferredFont(forTextStyle: .largeTitle))
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = true
        tf.keyboardType = .decimalPad
        tf.textColor = .label
        return tf
    }()
    
    // MARK: - TextField bottom border
    let bottomView = UIView()
    
    let tipValue: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.accessibilityHint = LocalizedString.tip_value_hint
        label.setSizeFont(sizeFont: 70)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    let totalValue: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.accessibilityHint = LocalizedString.total_value_hint
        label.setSizeFont(sizeFont: 70)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    let splitPeopleQuantity: UILabel = {
        let label = UILabel()
        label.setSizeFont(sizeFont: 35)
        label.textColor = .label
        return label
    }()
    
    let splitTotal: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setSizeFont(sizeFont: 35)
        label.textColor = .label
        return label
    }()
    
    let splitStepper: UIStepper = {
        let st = UIStepper()
        st.minimumValue = 1
        st.maximumValue = 10
        st.autorepeat = true
        st.value = 1
        return st
    }()
    
    // MARK: - Tip percentage selector with predefined options (10%, 15%, 20%, 25%)
    // Automatically recalculates tip and total when selection changes
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(
            items: Percentages.allCases.map { $0.description.capitalized }
        )
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .selected)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .secondarySystemFill
        return sc
    }()
    
    let clearValuesButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.counterclockwise")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .systemOrange
        config.background.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.12)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.title = LocalizedString.clear_value_button_title
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
            var attributes = AttributeContainer()
            attributes.font = .preferredFont(forTextStyle: .body)
            return attributes
        }
        btn.configuration = config
        btn.accessibilityHint = AccessibilityLabels.clearButtonHint
        return btn
    }()
    
    let presentSheetButton: UIButton = {
        let btn = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "list.bullet.rectangle.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .systemBlue
        config.background.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.title = LocalizedString.seeAll
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { _ in
            var attributes = AttributeContainer()
            attributes.font = .preferredFont(forTextStyle: .body)
            return attributes
        }
        btn.configuration = config
        btn.accessibilityHint = AccessibilityLabels.seeAllButtonHint
        return btn
    }()
    
    var calculationsViewModel: CalculationsViewModel?
    var saveViewModel: SaveViewModel?
    
    // MARK: - Speech Recognition Components
    // These properties handle voice input functionality for hands-free bill entry
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private lazy var micButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: Constant.mic)
        config.baseForegroundColor = .systemBlue
        config.background.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
        config.imagePadding = 4
        button.configuration = config
        button.accessibilityLabel = AccessibilityLabels.dictateBillValueLabel
        button.accessibilityHint = AccessibilityLabels.dictateTipValueHint
        button.addTarget(self, action: #selector(handleMicButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.contentMode = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculationsViewModel = CalculationsViewModel()
        saveViewModel = SaveViewModel()
        
        view.backgroundColor = UIColor(named: "backgroundSecondary") ?? .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        valueInput.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        segment.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        splitStepper.addTarget(self, action: #selector(changeStepperQuantity), for: .valueChanged)
        clearValuesButton.addTarget(self, action: #selector(handleResetFields), for: .touchUpInside)
        presentSheetButton.addTarget(self, action: #selector(handlePresentSheet), for: .touchUpInside)
        
        splitPeopleQuantity.text = "\(Int(splitStepper.value))x"
        splitPeopleQuantity.accessibilityLabel = "\(Int(splitStepper.value)) people"
        setNavbar()
        setUI()
        saveViewModel?.fetchItems()
        updateSavedRecordsButton()
        toastMessage.view.alpha = 0.0
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIInputViewController.dismissKeyboard)
            )
        )
        
        // Add mic button to valueInput
        valueInput.rightView = micButton
        valueInput.rightViewMode = .always
        requestSpeechAuthorization()
    }
    
    deinit {
        calculationsViewModel = nil
        saveViewModel = nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveViewModel?.fetchItems()
        updateSavedRecordsButton()
    }

    /// Updates the saved records button title with current count for better engagement
    func updateSavedRecordsButton() {
        let count = saveViewModel?.bills.count ?? 0
        let title = count > 0
            ? String(format: LocalizedString.savedRecordsCount, count)
            : LocalizedString.seeAll
        presentSheetButton.configuration?.title = title
    }

    @objc func handlePresentSheet() {
        let presentTipViewController = PresentingTipViewController()
        presentTipViewController.saveViewModel = saveViewModel
        present(presentTipViewController, animated: true)
    }
    
    /// Handles microphone button tap for voice input
    /// Toggles between start/stop dictation based on current audio engine state
    @objc private func handleMicButtonTapped() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        if audioEngine.isRunning {
            stopDictation()
        } else {
            startDictation()
        }
    }
    
    /// Updates mic button appearance based on recording state for clearer user feedback
    private func updateMicButtonAppearance(isRecording: Bool) {
        var config = micButton.configuration ?? UIButton.Configuration.plain()
        config.image = UIImage(systemName: isRecording ? Constant.micStop : Constant.mic)
        config.baseForegroundColor = isRecording ? .systemRed : .systemBlue
        config.background.backgroundColor = (isRecording ? UIColor.systemRed : UIColor.systemBlue).withAlphaComponent(0.12)
        micButton.configuration = config
        micButton.accessibilityLabel = isRecording ? AccessibilityLabels.stopDictationLabel : AccessibilityLabels.dictateBillValueLabel
        micButton.accessibilityHint = isRecording ? AccessibilityLabels.stopDictationHint : AccessibilityLabels.dictateTipValueHint
    }
    
}

extension MainController: SpeechControllerProtocol {
    // Requests microphone permission for speech recognition
    // Enables/disables mic button based on authorization status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.micButton.isEnabled = true
                default:
                    self.micButton.isEnabled = false
                }
            }
        }
    }
    
    // Initiates speech recognition session
    // Sets up audio session and begins real-time transcription
    func startDictation() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session properties weren't set because of an error.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { return }
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.valueInput.text = result.bestTranscription.formattedString
                self.changeValue()
            }
            if error != nil || (result?.isFinal ?? false) {
                self.stopDictation()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        updateMicButtonAppearance(isRecording: true)
    }
    
    // Stops speech recognition and cleans up audio resources
    // Resets microphone button to normal state
    func stopDictation() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        updateMicButtonAppearance(isRecording: false)
    }
}

extension UIImage {
    // Customize microphone icon padding size
    func withPadding(_ padding: UIEdgeInsets) -> UIImage? {
        let newSize = CGSize(
            width: self.size.width + padding.left + padding.right,
            height: self.size.height + padding.top + padding.bottom
        )
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        
        let origin = CGPoint(x: padding.left, y: padding.top)
        self.draw(at: origin)
        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return paddedImage
    }
}

// MARK: - PREVIEW SECTION BLOCK USING SWIFT UI API PREVIEW PROVIDER + SWIFT VERSION SUPPORT
#Preview {
    UIViewControllerPreview {
        MainController()
    }
}

