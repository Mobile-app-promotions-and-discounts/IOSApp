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

    private lazy var barcodeInputBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.backgroundColor = .cherryForeground
        return view
    }()

    private lazy var barcodeReminderLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        label.textColor = .cherryWhite
        label.font = CherryFonts.headerMedium
        label.text = NSLocalizedString("barcodeReminder", tableName: "ScanFlow", comment: "")
        label.textAlignment = .left
        return label
    }()

    private lazy var textField: UITextField = {
        let barcodeField = BarcodeTextField()
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
        let placeholderText = "•••••••• •••••"
        let placeholderAttributes = [NSAttributedString.Key.font: CherryFonts.textLarge,
                                     NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue,
                                     NSAttributedString.Key.kern: 7]
        let textAttributes = [NSAttributedString.Key.font: CherryFonts.textLarge,
                              NSAttributedString.Key.kern: 7]
        barcodeField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                attributes: placeholderAttributes as [NSAttributedString.Key: Any])
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
        let control = CustomSegmentedControl(items: [NSLocalizedString("barcodeScan",
                                                                       tableName: "ScanFlow",
                                                                       comment: ""),
                                                     NSLocalizedString("barcodeEntry",
                                                                       tableName: "ScanFlow",
                                                                       comment: "")])
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
        view.backgroundColor = .cherryGray

        scanPreviewLayer.frame = view.layer.bounds
        scanPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(scanPreviewLayer)
        view.layer.addSublayer(fillLayer)

        [scanFrame,
         modeControl,
         barcodeInputBackground,
         flashButton,
         backButton]
            .forEach {
                view.addSubview($0)
            }

        [textField,
         barcodeReminderLabel].forEach {
            barcodeInputBackground.addSubview($0)
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

        barcodeInputBackground.snp.makeConstraints { make in
            make.bottom.equalTo(modeControl.snp.top).offset(-80)
            make.height.equalTo(114)
            make.width.equalTo(modeControl)
            make.centerX.equalTo(modeControl)
        }

        textField.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(barcodeInputBackground).inset(8)
            make.leading.equalTo(barcodeInputBackground).offset(8)
        }

        barcodeReminderLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(barcodeInputBackground).offset(8)
            make.trailing.equalTo(barcodeInputBackground).inset(8)
            make.bottom.equalTo(textField.snp.top).offset(-8)
        }

        barcodeInputBackground.isHidden = true
        barcodeInputBackground.isUserInteractionEnabled = false

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

        // поведение интерфейса ввода штрихкода
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                UIView.animate(withDuration: 0.5) {
                    self.scanFrame.isHidden = manualInputUI
                    self.fillLayer.fillRule = manualInputUI ? .nonZero : .evenOdd
                    self.barcodeInputBackground.isHidden = !manualInputUI
                    self.fillLayer.isHidden = manualInputUI
                }
            }
            .store(in: &subscriptions)

        // поведение кнопки вспышки
        viewModel.manualInputUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] manualInputUI in
                guard let self else { return }
                if manualInputUI {
                    self.flashButton.isSelected = false
                }
                self.flashButton.isEnabled = !manualInputUI
                self.flashButton.isHidden = manualInputUI
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
                    captureSessionController.startSessionRoutine()
                } else {
                    textField.becomeFirstResponder()
                    self.modeControl.snp.remakeConstraints { make in
                        make.height.equalTo(52)
                        make.leading.equalTo(self.view).offset(16)
                        make.trailing.equalTo(self.view).offset(-16)
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
            .sink { [weak self] isValid in
                self?.barcodeReminderLabel.alpha = isValid ? 0.6 : 1
            }
            .store(in: &subscriptions)

        // обновление текстового поля по маске
        viewModel.barcodePlaceholderUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placeholder in
                guard let self else { return }
                self.textField.attributedText = formatPlaceholder(placeholder)
                var caretIndex = placeholder.filter { $0.isWholeNumber }.count
                if caretIndex > 8 { caretIndex += 1 }
                let caretPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: caretIndex) ?? self.textField.endOfDocument
                self.textField.selectedTextRange = self.textField.textRange(from: caretPosition, to: caretPosition)
            }
            .store(in: &subscriptions)
    }
}

extension ScanViewController {
    private func formatPlaceholder(_ placeholder: String) -> NSAttributedString {
        var dotIndex = placeholder.filter { $0.isWholeNumber }.count
        if dotIndex > 8 { dotIndex += 1 }
        let dotRemainder = placeholder.count - dotIndex

        let numberAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: CherryFonts.textLarge,
                                                               NSAttributedString.Key.foregroundColor: UIColor.cherryBlack,
                                                               NSAttributedString.Key.kern: 7]
        let dotAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: CherryFonts.textLarge,
                                                            NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue,
                                                            NSAttributedString.Key.kern: 7]

        let formattedPlaceholderNumbers = NSMutableAttributedString(string: String(placeholder.prefix(dotIndex)),
                                                                    attributes: numberAttributes)
        let formattedPlaceholderDots = NSAttributedString(string: String(placeholder.suffix(dotRemainder)),
                                                          attributes: dotAttributes)
        formattedPlaceholderNumbers.append(formattedPlaceholderDots)

        return formattedPlaceholderNumbers
    }

    // MARK: - Button selectors

    @objc
    private func toggleFlash() {
        captureSessionController.toggleFlash()
    }

    @objc
    private func goBack() {
        coordinator?.navigateBack()
    }

    @objc
    private func doneButtonTapped() {
        viewModel.checkBarcode()
    }
}
