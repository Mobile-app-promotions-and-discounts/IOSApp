import AVFoundation
import Combine
import SnapKit
import UIKit

final class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var coordinator: ScanFlowCoordinatorProtocol?
    private let viewModel: ScanFlowViewModel
    private var subscriptions = Set<AnyCancellable>()

    private var captureSession: AVCaptureSession
    private var previewLayer: AVCaptureVideoPreviewLayer

    // MARK: - UI elements
    private let scanFrame: UIView = {
        return ScanFrameView()
    }()

    private lazy var barcodeReminderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = NSLocalizedString("barcodeReminder", tableName: "ScanFlow", comment: "")
        label.textAlignment = .center
        return label
    }()

    private lazy var textField = {
        let barcodeField = UITextField()
        barcodeField.backgroundColor = .systemBackground
        barcodeField.keyboardType = .numberPad
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("barcodeDone",
                                                                             tableName: "ScanFlow",
                                                                             comment: ""),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(doneButtonTapped))
        barcodeField.addDoneButtonOnKeyboard(done)
        barcodeField.clipsToBounds = true
        barcodeField.layer.cornerRadius = 10
        barcodeField.placeholder = NSLocalizedString("barcodePlaceholder", tableName: "ScanFlow", comment: "")
        barcodeField.textAlignment = .center
        return barcodeField
    }()

    private lazy var flashButton = {
        let flashButton = GenericNavButton(type: .custom)
        flashButton.setImage(UIImage.init(systemName: "bolt"), for: .normal)
        flashButton.setImage(UIImage.init(systemName: "bolt.fill"), for: .selected)
        flashButton.addTarget(self,
                              action: #selector(toggleFlash),
                              for: .touchUpInside)
        return flashButton
    }()

    private lazy var backButton = {
        let backButton = GenericNavButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.addTarget(self,
                             action: #selector(goBack),
                             for: .touchUpInside)
        return backButton
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [scanButton, manualButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    private lazy var scanButton: UIButton = {
        let button = GenericButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeScan", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(scanButtonTapped),
                         for: .touchUpInside)
        button.isSelected = !viewModel.isManualInputActive
        return button
    }()

    private lazy var manualButton: UIButton = {
        let button = GenericButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeEntry", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(manualButtonTapped),
                         for: .touchUpInside)
        button.isSelected = viewModel.isManualInputActive
        return button
    }()

    // MARK: - Lifecycle
    init(coordinator: ScanFlowCoordinatorProtocol? = nil, viewModel: ScanFlowViewModel = ScanFlowViewModel()) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.captureSession = AVCaptureSession()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemFill

        [scanFrame,
         buttonStack,
         textField,
         barcodeReminderLabel]
            .forEach {
                view.addSubview($0)
            }

        flashButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
        }

        scanFrame.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(164)
            make.leading.equalToSuperview().offset(58)
            make.trailing.equalToSuperview().offset(-58)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flashButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.equalTo(view).offset(18)
            make.trailing.equalTo(view).offset(-18)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        textField.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStack.snp.top).offset(-80)
            make.height.equalTo(68)
            make.width.equalTo(buttonStack)
            make.centerX.equalTo(buttonStack)
        }
        textField.isHidden = !viewModel.isManualInputActive

        barcodeReminderLabel.snp.makeConstraints { make in
            make.size.equalTo(textField)
            make.centerX.equalTo(textField)
            make.bottom.equalTo(textField.snp.top)
        }
        barcodeReminderLabel.isHidden = true
    }

    // MARK: UI Binding
    private func makeUIBinding() {
        // TODO: планирую поработать над более изящной реализацией Combine в этом методе
        let uiStateConfugurator = viewModel.$isManualInputActive.map { value in
            return !value
        }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scanUI in
                guard let self else { return }
                self.scanButton.isSelected = scanUI
                self.manualButton.isSelected = !scanUI
                self.scanFrame.isHidden = !scanUI
                self.textField.isHidden = scanUI
                if scanUI {
                    textField.resignFirstResponder()
                    self.buttonStack.snp.remakeConstraints { make in
                        make.height.equalTo(44)
                        make.leading.equalTo(self.view).offset(18)
                        make.trailing.equalTo(self.view).offset(-18)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(0.0)
                    }
                    startSessionRoutine()
                } else {
                    textField.becomeFirstResponder()
                    self.buttonStack.snp.remakeConstraints { make in
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
            }

        let isReminderVisible = viewModel.bindBarcode(code: textField.textPublisher)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isHidden, on: barcodeReminderLabel)

        subscriptions.insert(uiStateConfugurator)
        subscriptions.insert(isReminderVisible)
    }
}

// MARK: - Capture Session
extension ScanViewController {
    private func startSessionRoutine() {
        if captureSession.isRunning == false {
            let background = DispatchQueue(label: "capture_session_queue")
            background.async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    private func stopSessionRoutine() {
        flashOff()
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        } else {
            failed()
            return
        }

        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        let background = DispatchQueue(label: "capture_session_queue")
        background.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    private func failed() {
        coordinator?.scanError()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            flashOff()
            viewModel.checkBarcode(code: stringValue)
        }
    }
}

// MARK: - Flashlight
extension ScanViewController {
    private func flashOff() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashButton.isSelected = false
            }

            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    @objc
    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()

            if device.torchMode == AVCaptureDevice.TorchMode.on {
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

// MARK: - Button selectors
extension ScanViewController {
    @objc
    private func goBack() {
        coordinator?.goBack()
    }

    @objc
    private func doneButtonTapped() {
        viewModel.checkBarcode()
    }

    @objc
    private func scanButtonTapped() {
        viewModel.setManualInputActive(to: false)
    }

    @objc
    private func manualButtonTapped() {
        viewModel.setManualInputActive(to: true)
    }
}