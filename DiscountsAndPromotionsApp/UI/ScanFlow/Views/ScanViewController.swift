import AVFoundation
import Combine
import SnapKit
import UIKit

final class ScanViewController: UIViewController {
    weak var coordinator: ScanFlowCoordinator?
    private let viewModel: ScanFlowViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var captureSessionController: ScanCaptureSessionController

    private var scanPreviewLayer: AVCaptureVideoPreviewLayer

    // MARK: - UI elements
    private let scanFrame: UIView = {
        return ScanFrameView()
    }()
    private let fillLayer = CAShapeLayer()

    private lazy var barcodeReminderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryWhite
        label.font = CherryFonts.headerMedium
        label.text = NSLocalizedString("barcodeReminder", tableName: "ScanFlow", comment: "")
        label.textAlignment = .left
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
        done.tintColor = .cherryMainAccent
        barcodeField.addDoneButtonOnKeyboard(done)
        barcodeField.backgroundColor = UIColor.cherryWhite
        barcodeField.clipsToBounds = true
        barcodeField.layer.cornerRadius = CornerRadius.regular.cgFloat()
        barcodeField.layer.borderWidth = 1
        barcodeField.layer.borderColor = UIColor.cherryGrayBlue.cgColor
        let placeholderText = NSLocalizedString("barcodePlaceholder", tableName: "ScanFlow", comment: "")
        let placeholderAttributes = [NSAttributedString.Key.font: CherryFonts.textLarge,
                                     NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue]
        let textAttributes = [NSAttributedString.Key.font: CherryFonts.textLarge]
        barcodeField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes as [NSAttributedString.Key: Any])
        barcodeField.defaultTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        barcodeField.textColor = UIColor.cherryBlack
        barcodeField.textAlignment = .center
        return barcodeField
    }()

    private lazy var flashButton = {
        let flashButton = ScannerNavButton(type: .custom)
        flashButton.setImage(.icFlashOff, for: .normal)
        flashButton.setImage(.icFlashOn, for: .selected)
        flashButton.addTarget(self,
                              action: #selector(toggleFlash),
                              for: .touchUpInside)
        return flashButton
    }()

    private lazy var backButton = {
        let backButton = ScannerNavButton(type: .system)
        backButton.setImage(.icBack, for: .normal)
        backButton.addTarget(self,
                             action: #selector(goBack),
                             for: .touchUpInside)
        return backButton
    }()

    private lazy var modeControl: UISegmentedControl = {
        let control = CustomSegmentedControl(items: [NSLocalizedString("barcodeScan", tableName: "ScanFlow", comment: ""),
                                                 NSLocalizedString("barcodeEntry", tableName: "ScanFlow", comment: "")])
        control.backgroundColor = .cherryWhite
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        control.tintColor = .cherryMainAccent
        control.setTitleTextAttributes([NSAttributedString.Key.font: CherryFonts.headerMedium,
                                        NSAttributedString.Key.foregroundColor: UIColor.cherryWhite], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.font: CherryFonts.headerMedium,
                                        NSAttributedString.Key.foregroundColor: UIColor.cherryMainAccent], for: .normal)
        control.selectedSegmentIndex = 0
        control.layer.cornerRadius = 26
        control.clipsToBounds = true
        return control
    }()

    // MARK: - Lifecycle
    init(viewModel: ScanFlowViewModel,
         captureSessionController: ScanCaptureSessionController,
         scanPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.viewModel = viewModel
        self.captureSessionController = captureSessionController
        self.scanPreviewLayer = scanPreviewLayer
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
        view.backgroundColor = .cherryBlack

        scanPreviewLayer.frame = view.layer.bounds
        scanPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(scanPreviewLayer)
        view.layer.addSublayer(fillLayer)

        [scanFrame,
         modeControl,
         textField,
         barcodeReminderLabel,
         flashButton,
         backButton]
            .forEach {
                view.addSubview($0)
            }

        flashButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.trailing.equalToSuperview().offset(-6)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.leading.equalToSuperview().offset(6)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        scanFrame.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(170)
            make.leading.equalToSuperview().offset(55)
            make.trailing.equalToSuperview().offset(-55)
        }

        modeControl.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        textField.snp.makeConstraints { make in
            make.bottom.equalTo(modeControl.snp.top).offset(-80)
            make.height.equalTo(71)
            make.width.equalTo(modeControl)
            make.centerX.equalTo(modeControl)
        }
        textField.isHidden = true

        barcodeReminderLabel.snp.makeConstraints { make in
            make.width.equalTo(textField)
            make.centerX.equalTo(textField)
            make.bottom.equalTo(textField.snp.top).offset(-8)
        }
        barcodeReminderLabel.isHidden = true

        let cutoutOrigin = CGPoint(x: 55 + 2, y: view.frame.height/2 - 85 + 2)
        let cutoutSize = CGSize(width: view.frame.width - 110 - 4, height: 170 - 4)
        let pathBigRect = UIBezierPath(rect: view.frame)
        let pathSmallRect = UIBezierPath(rect: CGRect(origin: cutoutOrigin, size: cutoutSize))

        pathBigRect.append(pathSmallRect)
        pathBigRect.usesEvenOddFillRule = true

        fillLayer.path = pathBigRect.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.cherryForeground.cgColor
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

        let modePublisher = modeControl.segmentPublisher()
        viewModel.bindSegmentedControl(index: modePublisher)
//        // поведение кнопок выбора режима
//        viewModel.manualInputUpdate
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] manualInputUI in
//                guard let self else { return }
//                self.scanButton.isSelected = !manualInputUI
//                self.manualButton.isSelected = manualInputUI
//            }
//            .store(in: &subscriptions)

        // поведение интерфейса ввода штрихкода
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                UIView.animate(withDuration: 0.5) {
                    self.scanFrame.isHidden = manualInputUI
                    self.fillLayer.fillRule = manualInputUI ? .nonZero : .evenOdd
                    self.textField.isHidden = !manualInputUI
                }
            }
            .store(in: &subscriptions)

        // поведение кнопки вспышки
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                if manualInputUI {
                    self?.flashButton.isSelected = false
                }
                self?.flashButton.isEnabled = !manualInputUI
            }
            .store(in: &subscriptions)

        // настройка привязки кнопок к клавиатуре
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                if !manualInputUI {
                    textField.resignFirstResponder()
                    self.modeControl.snp.remakeConstraints { make in
                        make.height.equalTo(52)
                        make.leading.equalTo(self.view).offset(16)
                        make.trailing.equalTo(self.view).offset(-16)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(0.0)
                    }
                } else {
                    textField.becomeFirstResponder()
                    self.modeControl.snp.remakeConstraints { make in
                        make.height.equalTo(52)
                        make.leading.equalTo(self.view).offset(16)
                        make.trailing.equalTo(self.view).offset(-16)
                        make.centerX.equalTo(self.view)
                        make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-24.0)
                    }
                    captureSessionController.pauseSessionRoutine()
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

//    @objc
//    private func scanButtonTapped() {
//        viewModel.setManualInputActive(to: false)
//    }
//
//    @objc
//    private func manualButtonTapped() {
//        viewModel.setManualInputActive(to: true)
//    }
}
