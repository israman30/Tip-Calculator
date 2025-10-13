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
    
    // MARK: - TextField with editingChanged event, that allows to interact with the label tip and total
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: LocalizedString.textField_placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray
            ]
        )
        tf.accessibilityHint = LocalizedString.textField_hint
        tf.setDynamicFont(font: .preferredFont(forTextStyle: .title1))
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
    
    // MARK: - Segmented Controller with value changed event for tip percentage
    let segment: UISegmentedControl = {
        let sc = UISegmentedControl(
            items: Percentages.allCases.map { $0.description.capitalized }
        )
        let font = UIFont.preferredFont(forTextStyle: .title2)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .selected)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let clearValuesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(LocalizedString.clear_value_button_title, for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 8
        btn.accessibilityHint = AccessibilityLabels.clearButtonHint
        return btn
    }()
    
    let presentSheetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(LocalizedString.seeAll, for: .normal)
        btn.titleLabel?.setDynamicFont(font: .preferredFont(forTextStyle: .body))
        btn.accessibilityHint = AccessibilityLabels.seeAllButtonHint
        return btn
    }()
    
    var calculationsViewModel: CalculationsViewModel?
    var saveViewModel: SaveViewModel?
    
    // Speech recognition properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private lazy var micButton: UIButton = {
        let button = UIButton(type: .system)
        if let micImage = UIImage(systemName: Constant.mic) {
            let paddedImage = micImage.withPadding(.init(top: 0, left: 8, bottom: 0, right: 0))
            button.setImage(paddedImage, for: .normal)
        } else {
            button.setImage(UIImage(systemName: Constant.mic), for: .normal)
        }
        button.tintColor = .systemBlue
        button.accessibilityLabel = AccessibilityLabels.dictateBillValueLabel
        button.accessibilityHint = AccessibilityLabels.dictateTipValueHint
        button.addTarget(self, action: #selector(handleMicButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.contentMode = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculationsViewModel = CalculationsViewModel()
        saveViewModel = SaveViewModel()
        
        view.backgroundColor = UIColor(named: "backgroundPrimary")
        view.backgroundColor = UIColor(named: "backgroundSecondary")
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
    
    @objc func handlePresentSheet() {
        let presentTipViewController = PresentingTipViewController()
        present(presentTipViewController, animated: true)
    }
    
    /// `Dictation handler`
    @objc private func handleMicButtonTapped() {
        if audioEngine.isRunning {
            stopDictation()
        } else {
            startDictation()
        }
    }
    
}

extension MainController: SpeechControllerProtocol {
    // Reques authorization for audio usage
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
    
    // Start dictation
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
        
        micButton.tintColor = .systemRed // Indicate recording
    }
    
    // Stop dictation
    func stopDictation() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        micButton.tintColor = .systemBlue // Back to normal
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

