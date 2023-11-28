import AVFoundation
import Combine
import SnapKit
import UIKit

final class ScanViewController: UIViewController {
    weak var coordinator: ScanFlowCoordinatorProtocol?
    private let viewModel: ScanFlowViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var captureSessionController: ScanCaptureSessionController

    private var scanPreviewLayer: AVCaptureVideoPreviewLayer

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
        button.isSelected = true
        return button
    }()

    private lazy var manualButton: UIButton = {
        let button = GenericButton(type: .custom)
        button.setTitle(NSLocalizedString("barcodeEntry", tableName: "ScanFlow", comment: ""),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(manualButtonTapped),
                         for: .touchUpInside)
        button.isSelected = false
        return button
    }()

    // MARK: - Lifecycle
    init(coordinator: ScanFlowCoordinatorProtocol? = nil, viewModel: ScanFlowViewModel = ScanFlowViewModel()) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.captureSessionController = ScanCaptureSessionController(coordinator: self.coordinator)
        self.scanPreviewLayer = self.captureSessionController.previewLayer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSessionController.setupCaptureSession()
        setupUI()
        bindViewModel()
        bindCaptureSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSessionController.startSessionRoutine()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        captureSessionController.stopSessionRoutine()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemFill

        scanPreviewLayer.frame = view.layer.bounds
        scanPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(scanPreviewLayer)

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
        textField.isHidden = true

        barcodeReminderLabel.snp.makeConstraints { make in
            make.size.equalTo(textField)
            make.centerX.equalTo(textField)
            make.bottom.equalTo(textField.snp.top)
        }
        barcodeReminderLabel.isHidden = true
    }

    // MARK: UI Binding
    private func bindCaptureSession() {
        // поведение кнопки вспышки
        captureSessionController.$isFlashOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSelected, on: flashButton)
            .store(in: &subscriptions)

        // подписка на распознанный сканером штрих-код
        captureSessionController.$barcode
            .sink { [weak self] code in
                if let code {
                    self?.viewModel.checkBarcode(code: code)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindViewModel() {
        // поведение кнопок выбора режима
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                self.scanButton.isSelected = !manualInputUI
                self.manualButton.isSelected = manualInputUI
            }
            .store(in: &subscriptions)

        // поведение интерфейса ввода штрихкода
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                self.scanFrame.isHidden = manualInputUI
                self.textField.isHidden = !manualInputUI
                scanPreviewLayer.isHidden = manualInputUI
            }
            .store(in: &subscriptions)

        // поведение кнопки вспышки
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                if manualInputUI {
                    self?.flashButton.isSelected = false
                    self?.flashButton.isEnabled = !manualInputUI
                }
            }
            .store(in: &subscriptions)

        // настройка привязки кнопок к клавиатуре
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                if !manualInputUI {
                    textField.resignFirstResponder()
                    self.buttonStack.snp.remakeConstraints { make in
                        make.height.equalTo(44)
                        make.leading.equalTo(self.view).offset(18)
                        make.trailing.equalTo(self.view).offset(-18)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(0.0)
                    }
                    captureSessionController.startSessionRoutine()
                } else {
                    textField.becomeFirstResponder()
                    self.buttonStack.snp.remakeConstraints { make in
                        make.height.equalTo(44)
                        make.leading.equalTo(self.view).offset(18)
                        make.trailing.equalTo(self.view).offset(-18)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-24.0)
                    }
                    captureSessionController.stopSessionRoutine()
                }
            }
            .store(in: &subscriptions)

        // подписка на штрих-код, введенный вручная
        viewModel.bindBarcode(code: textField.textPublisher)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isHidden, on: barcodeReminderLabel)
            .store(in: &subscriptions)
    }
}

// MARK: - Button selectors
extension ScanViewController {
    @objc
    private func toggleFlash() {
        captureSessionController.toggleFlash()
    }

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
