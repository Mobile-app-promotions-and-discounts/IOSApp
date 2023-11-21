//
//  ScanViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import AVFoundation
import Combine
import SnapKit
import UIKit

final class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @Published private var manualInputMode = false
    private var uiSubscriber: AnyCancellable?
    private var isShowingScanUI: AnyPublisher<Bool, Never> {
        $manualInputMode.map { value in
            return !value
        }
        .eraseToAnyPublisher()
    }
        
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: - UI elements
    private let scanFrame: UIView = {
        return ScanFrameView()
    }()
    
    private lazy var textField = {
        let tf = UITextField()
        tf.backgroundColor = .systemBackground
        tf.keyboardType = .numberPad
        tf.doneAccessory = true
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.placeholder = NSLocalizedString("barcodePlaceholder", tableName: "ScanFlow", comment: "")
        tf.textAlignment = .center
       return tf
    }()
    
    private var flashButton = {
        let flashButton = UIButton(type: .custom)
    flashButton.backgroundColor = .systemBackground
    flashButton.setImage(UIImage.init(systemName: "bolt"), for: .normal)
    flashButton.setImage(UIImage.init(systemName: "bolt.fill"), for: .selected)
        flashButton.snp.makeConstraints{ (maker) in
            maker.height.equalTo(44)
            maker.width.equalTo(44)
        }
        flashButton.clipsToBounds = true
            flashButton.layer.cornerRadius = 22
    return flashButton
    }()
    
    private var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var scanButton: UIButton = {
        let button = CherryButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeScan", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(scanButtonTapped),
                         for: .touchUpInside)
        button.isSelected = !manualInputMode
        return button
    }()
    
    private lazy var manualButton: UIButton = {
        let button = CherryButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeEntry", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(manualButtonTapped),
                         for: .touchUpInside)
        button.isSelected = manualInputMode
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupCaptureSession()
        setupUI()
        makeUIBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startSessionRoutine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopSessionRoutine()
    }
    
    //MARK: - Setup UI
    func setupUI() {
        view.backgroundColor = .systemFill
        
        view.addSubview(scanFrame)
        scanFrame.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.height.equalTo(164)
            make.leading.equalToSuperview().offset(58)
            make.trailing.equalToSuperview().offset(-58)
        }
        
        flashButton.addTarget(self,
                              action: #selector(toggleFlash),
                              for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flashButton)
        navigationItem.backButtonDisplayMode = .minimal
        
        view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(scanButton)
        buttonStack.addArrangedSubview(manualButton)
        buttonStack.snp.makeConstraints{ make in
            make.height.equalTo(44)
            make.leading.equalTo(view).offset(18)
            make.trailing.equalTo(view).offset(-18)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints{ make in
            make.bottom.equalTo(buttonStack.snp.top).offset(-80)
            make.height.equalTo(68)
            make.width.equalTo(buttonStack)
            make.centerX.equalTo(buttonStack)
        }
        textField.isHidden = !manualInputMode
    }
    
    //MARK: UI Binding
    func makeUIBinding() {
        uiSubscriber = isShowingScanUI
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] scanUI in
                guard let self else { return }
                self.scanButton.isSelected = scanUI
                self.manualButton.isSelected = !scanUI
                self.scanFrame.isHidden = !scanUI
                self.textField.isHidden = scanUI
                if scanUI {
                    textField.resignFirstResponder()
                    self.buttonStack.snp.remakeConstraints{ make in
                        make.height.equalTo(44)
                        make.leading.equalTo(self.view).offset(18)
                        make.trailing.equalTo(self.view).offset(-18)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(0.0)
                    }
                    startSessionRoutine()
                } else {
                    textField.becomeFirstResponder()
                    self.buttonStack.snp.remakeConstraints{ make in
                        make.height.equalTo(44)
                        make.leading.equalTo(self.view).offset(18)
                        make.trailing.equalTo(self.view).offset(-18)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-24.0)
                    }
                    stopSessionRoutine()
                }
                flashButton.isEnabled = scanUI
                previewLayer.isHidden = !scanUI
            })
    }
    
    //MARK: - Capture Session
    private func startSessionRoutine() {
        if (captureSession?.isRunning == false) {
            let background = DispatchQueue(label: "capture_session_queue")
            background.async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    private func stopSessionRoutine() {
        flashOff()
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let background = DispatchQueue(label: "capture_session_queue")
        background.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    //TODO: Handle Errors and strings
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            print(readableObject.type)
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            flashOff()
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK: - Flashlight
extension ScanViewController {
    func flashOff() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashButton.isSelected = false
            }
            
            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    @objc
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashButton.isSelected = false
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    flashButton.isSelected = true
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

//MARK: - Button selectors
extension ScanViewController {
    @objc
    func scanButtonTapped() {
        manualInputMode = false
    }
    
    @objc
    func manualButtonTapped() {
        manualInputMode = true
    }
}


