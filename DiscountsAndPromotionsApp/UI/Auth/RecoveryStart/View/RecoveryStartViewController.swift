import Combine
import SnapKit
import UIKit

final class RecoveryStartViewController: UIViewController {
    
    weak var coordinator: AuthCoordinator?
    private let viewModel: RecoveryStartViewModelProtocol
    private var cancellables: Set<AnyCancellable>
    
    private lazy var recoveryLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.RecoveryStart.title
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = CherryFonts.titleExtraLarge
        label.textColor = .cherryBlack
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ic_back") ?? UIImage()
        button.setImage(image, for: .normal)
        button.tintColor = .cherryBlack
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var sentLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.RecoveryStart.sentCode
        label.textColor = .cherryBlack
        label.textAlignment = .center
        label.font = CherryFonts.textMedium
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var textFeildsHStack: UIStackView = {
        var textFields = [UITextField]()
        for dataTextField in viewModel.dataTextFields {
            let textField = createTextField(tag: dataTextField.id, delegate: self)
            textFields.append(textField)
        }
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Const.TextFieldStack.spacing
        return stackView
    }()
    
    private lazy var timeTextLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.RecoveryStart.sendCode
        label.textColor = .cherryBlack
        label.textAlignment = .left
        label.font = CherryFonts.textMedium
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "60 " + L10n.RecoveryStart.time
        label.textColor = .cherryMainAccent
        label.textAlignment = .right
        label.font = CherryFonts.headerMedium
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timerHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeTextLabel,timerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = Const.SendHStack.spacing
        return stackView
    }()
    
    private lazy var sendAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.RecoveryStart.sendCodeButton, for: .normal)
        button.titleLabel?.font = CherryFonts.headerMedium
        button.setTitleColor(.cherryMainAccent, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sendAgainAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var willSendLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.RecoveryStart.willSendCode
        label.textColor = .cherryBlack
        label.textAlignment = .center
        label.font = CherryFonts.textMedium
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var recoveryButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.RecoveryStart.recoveryButton, for: .normal)
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(recoveryAction), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: RecoveryStartViewModelProtocol) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindingOn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }
    
    private func bindingOn() {
        
        viewModel.timeLeft
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTime in
                self?.setTime(newTime)
            }.store(in: &cancellables)
        
        viewModel.isTimerEnded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTimeEnded in
                self?.isTimerEnded(isTimeEnded)
            }.store(in: &cancellables)
        
        viewModel.isCodeDone
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: recoveryButton)
            .store(in: &cancellables)
    }
    
    private func bindingOff() {
        cancellables.removeAll()
    }
    
    //MARK: Methods
    private func createTextField(tag: Int, delegate: UITextFieldDelegate) -> UITextField {
        let textField = UITextField()
        textField.tag = tag
        textField.delegate = delegate
        textField.font = CherryFonts.textLarge
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.textColor = .cherryBlack
        textField.keyboardType = .numberPad
        textField.backgroundColor = .cherryLightBlue
        textField.addTarget(self, action: #selector(changeTextField(_:)), for: .editingChanged)
        return textField
    }
    
    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Const.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setTime(_ time: Int) {
        timerLabel.text = String(time) + " " + L10n.RecoveryStart.time
    }
    
    private func isTimerEnded(_ isEnded: Bool) {
        timerHStack.isHidden = isEnded
        sendAgainButton.isHidden = !isEnded
    }
        
    @objc private func backAction() {
        coordinator?.popToNavigate()
    }
    
    @objc private func changeTextField(_ textField: UITextField) {
        let tag = textField.tag
        let text = textField.text ?? ""
        viewModel.changeTextField(id: tag, text: text)
    }
    
    @objc private func sendAgainAction() {
        viewModel.sendCode()
    }
    
    @objc private func recoveryAction() {
        coordinator?.navigateToRecoveryEndScreen()
    }
    
    private func setupConstraints() {
        [recoveryLabel,
         backButton,
         sentLabel,
         textFeildsHStack,
         timerHStack,
         sendAgainButton,
         willSendLabel,
         recoveryButton].forEach { view.addSubview($0) }
        
        recoveryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
                .offset(Const.RecoveryLabel.topOffset)
            $0.leading.equalToSuperview()
                .offset(Const.RecoveryLabel.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.RecoveryLabel.trailingOffset)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(Const.BackButton.topOffset)
            $0.leading.equalToSuperview()
                .offset(Const.BackButton.leadingOffset)
        }
        
        sentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(recoveryLabel.snp.bottom)
                .offset(Const.SentLabel.topOffset)
            $0.leading.equalToSuperview()
                .offset(Const.SentLabel.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.SentLabel.trailingOffset)
        }
        
        textFeildsHStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Const.TextFieldStack.height)
            $0.top.equalTo(sentLabel.snp.bottom)
                .offset(Const.TextFieldStack.topOffset)
            $0.leading.equalToSuperview()
                .offset(Const.TextFieldStack.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.TextFieldStack.trailingOffset)
        }
        
        timerHStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textFeildsHStack.snp.bottom)
                .offset(Const.SendHStack.topOffset)
        }
        
        sendAgainButton.snp.makeConstraints {
            $0.center.equalTo(timerHStack.snp.center)
        }
        
        willSendLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(recoveryButton.snp.top)
                .offset(Const.WillSendLabel.bottomOffset)
            $0.leading.equalToSuperview()
                .offset(Const.WillSendLabel.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.WillSendLabel.trailingOffset)
        }
        
        recoveryButton.snp.makeConstraints {
            $0.height.equalTo(Const.RecoveryButton.height)
            $0.bottom.equalToSuperview()
                .offset(Const.RecoveryButton.bottomOffset)
            $0.leading.equalToSuperview()
                .offset(Const.RecoveryButton.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.RecoveryButton.trailingOffset)
        }

    }
    
    private enum Const {
        enum View {
            static let cornerRadius: CGFloat = 12
        }
        enum RecoveryLabel {
            static let topOffset: CGFloat = 32
            static let leadingOffset: CGFloat = 65
            static let trailingOffset: CGFloat = -65
        }
        enum BackButton {
            static let topOffset: CGFloat = 35
            static let leadingOffset: CGFloat = 16
        }
        enum SentLabel {
            static let topOffset: CGFloat = 28
            static let leadingOffset: CGFloat = 16
            static let trailingOffset: CGFloat = -16
        }
        enum TextFieldStack {
            static let spacing: CGFloat = 8
            static let height: CGFloat = 63
            static let topOffset: CGFloat = 12
            static let leadingOffset: CGFloat = 60
            static let trailingOffset: CGFloat = -60
        }
        enum SendHStack {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 12
        }
        enum WillSendLabel {
            static let bottomOffset: CGFloat = -12
            static let leadingOffset: CGFloat = 16
            static let trailingOffset: CGFloat = -16
        }
        enum RecoveryButton {
            static let height: CGFloat = 51
            static let bottomOffset: CGFloat = -24
            static let leadingOffset: CGFloat = 16
            static let trailingOffset: CGFloat = -16
        }
    }
    
}

extension RecoveryStartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}