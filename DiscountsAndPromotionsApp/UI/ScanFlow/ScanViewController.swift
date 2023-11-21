//
//  ScanViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import AVFoundation
import SnapKit
import UIKit

enum BarcodeInput {
    case scan
    case manual
}

final class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//    private var mode: BarcodeInput = .scan {
//        didSet {
//            switch mode {
//            case .manual:
//                
//            case .scan:
//            }
//        }
//    }
    
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
        return button
    }()
    
    private lazy var manualButton: UIButton = {
        let button = CherryButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeEntry", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(manualButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupCaptureSession()
        setupUI()
    }
    
    //MARK: - Setup UI
    func setupUI() {
//        view.addSubview(textField)
//        textField.snp.makeConstraints{ make in
//            make.center.equalToSuperview()
//            make.height.equalTo(80)
//            make.width.equalTo(260)
//        }
        
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
            
            view.backgroundColor = .systemBackground
            view.addSubview(buttonStack)
            buttonStack.addArrangedSubview(scanButton)
            buttonStack.addArrangedSubview(manualButton)
            buttonStack.snp.makeConstraints{ make in
                make.height.equalTo(44)
                make.leading.equalTo(view).offset(18)
                make.trailing.equalTo(view).offset(-18)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-24)
            }
        }
    
    //MARK: - Capture Session
    func setupCaptureSession() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        flashOff()
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
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
        
//        dismiss(animated: true)
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
        scanButton.isSelected.toggle()
    }
    
    @objc
    func manualButtonTapped() {
        manualButton.isSelected.toggle()
    }
}


