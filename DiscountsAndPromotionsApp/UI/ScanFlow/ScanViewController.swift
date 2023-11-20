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
        stack.backgroundColor = .systemBackground
        return stack
    }()
    
    private var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SCAN", for: .normal)
        return button
    }()
    
    private var manualButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("MANUAL", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupCaptureSession()
        setupUI()
    }
    
    func setupUI() {
        let tf = UITextField()
        tf.backgroundColor = .red
        view.addSubview(tf)
        tf.snp.makeConstraints{ (maker) in
            maker.center.equalToSuperview()
            maker.height.equalTo(80)
            maker.width.equalTo(260)
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
            buttonStack.snp.makeConstraints{ (maker) in
                maker.height.equalTo(60)
                maker.width.equalTo(view)
                maker.centerX.equalTo(view)
                maker.centerY.equalTo(view.keyboardLayoutGuide).offset(-40)
            }
        }
    
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
        
        dismiss(animated: true)
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
