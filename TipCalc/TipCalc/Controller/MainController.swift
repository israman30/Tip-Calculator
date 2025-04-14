//
//  MainController.swift
//  TipCalc
//
//  Created by Israel Manzo on 7/29/19.
//  Copyright © 2019 Israel Manzo. All rights reserved.
//

import UIKit
import SwiftUI

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

class MainController: UIViewController, TableViewProtocol, SetUIProtocol, CalculationsViewModelProtocol, SaveViewModelProtocol {
    
    let toastMessage = UIHostingController(rootView: ToastMessage())
    
    private var speechAnalyzer = SpeechRecognitionController()
    
    // MARK: - TableView display list of saved bills
    var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.allowsSelection = false
        return tv
    }()
    
    let iconImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "microphone"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    // MARK: - TextField with editingChanged event, that allows to interact with the label tip and total
    let valueInput: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: LocalizedString.textField_placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label
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
        label.setSizeFont(sizeFont: 25)
        label.textColor = .label
        return label
    }()
    
    let splitTotal: UILabel = {
        let label = UILabel()
        label.text = Constant.zero
        label.setSizeFont(sizeFont: 25)
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
        btn.titleLabel?.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 8
        btn.accessibilityHint = AccessibilityLabels.clearButtonHint
        return btn
    }()
    
    let presentSheetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(LocalizedString.seeAll, for: .normal)
        btn.titleLabel?.setDynamicFont(font: .preferredFont(forTextStyle: .subheadline))
        btn.accessibilityHint = AccessibilityLabels.seeAllButtonHint
        return btn
    }()
    
    var calculationsViewModel: CalculationsViewModel?
    var saveViewModel: SaveViewModel?
    
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
        
        iconImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSpeechRecognition)))
        
        splitPeopleQuantity.text = "\(Int(splitStepper.value))x"
        splitPeopleQuantity.accessibilityLabel = "\(Int(splitStepper.value)) people"
        setNavbar()
        setUI()
        tableViewHandlers()
        saveViewModel?.fetchItems()
        toastMessage.view.alpha = 0.0
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(UIInputViewController.dismissKeyboard)
            )
        )
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
    
    @objc func handleSpeechRecognition() {
        toggleSpeechRecognition()
        valueInput.text = speechAnalyzer.recognizedText
        print("Button Tapped")
    }
    
    func toggleSpeechRecognition() {
        if speechAnalyzer.isProcessing {
            speechAnalyzer.stop()
        } else {
            speechAnalyzer.start()
        }
    }
    
    
}


// MARK: - PREVIEW SECTION BLOCK USING SWIFT UI API PREVIEW PROVIDER + SWIFT VERSION SUPPORT


#Preview {
    UIViewControllerPreview {
        MainController()
    }
}

import Speech

class SpeechRecognitionController: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?
    
    var recognizedText: String?
    var isProcessing: Bool = false
    
    var inputValue: String = ""
    
    func start() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
        
        inputNode = audioEngine.inputNode
        
        speechRecognizer = SFSpeechRecognizer()
        print("Supports on device recognition: \(speechRecognizer?.supportsOnDeviceRecognition == true ? "✅" : "🔴")")
        
        // Force specified locale
        // self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pl_PL"))
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Disable partial results
        // recognitionRequest?.shouldReportPartialResults = false
        
        // Enable on-device recognition
        // recognitionRequest?.requiresOnDeviceRecognition = true
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.recognizedText = result?.bestTranscription.formattedString
            
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Coudn't start audio engine!")
            stop()
        }
    }
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        
        inputNode?.removeTap(onBus: 0)
        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}
