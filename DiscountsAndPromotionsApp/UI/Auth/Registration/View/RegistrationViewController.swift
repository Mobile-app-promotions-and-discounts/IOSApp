import Combine
import SnapKit
import UIKit

class RegistrationViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let viewModel: RegistrationViewModelProtocol

    private var cancellables: Set<AnyCancellable>
    
    private lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Registration.entryTitle
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

    private lazy var inputEmailField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Registration.emailTitle
        field.placeholder = "ivanov@example.com"
        field.textField.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        return field
    }()

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Registration.passwordTitle
        field.placeholder = "cherryapp"
        field.textField.addTarget(self, action: #selector(changePassword(_:)), for: .editingChanged)
        field.isShowHidePasswordButtonVisible = true
        return field
    }()

    private lazy var inputFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [inputEmailField, inputPasswordField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.TextFieldsStack.spacing
        return stackView
    }()
    
    private lazy var privatePolicyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Registration.privacyPolicyTitle
        label.numberOfLines = 2
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var privatePolicyLabelTap: UILabel = {
        let label = UILabel()
        label.text = L10n.Registration.privacyPolicy
        label.numberOfLines = 1
        label.font = CherryFonts.textMedium
        label.textColor = .cherryMainAccent
        label.textAlignment = .center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(policyAction)))
        return label
    }()

    private lazy var registrationButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.Registration.registrationTitle, for: .normal)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return button
    }()

    init(viewModel: RegistrationViewModelProtocol = RegistrationViewModel()) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isUserInteractionEnabled, on: registrationButton)
            .store(in: &cancellables)
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Constants.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupConstraints() {
        [registrationLabel,backButton, inputFieldsStack, privatePolicyLabel, privatePolicyLabelTap, registrationButton].forEach { view.addSubview($0) }

        registrationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
                .offset(Constants.EntryLabel.topOffset)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(registrationLabel.snp.centerY)
            make.leading.equalToSuperview()
                .offset(Constants.BackButton.leadingOffset)
            make.height.equalTo(Constants.BackButton.heightWight)
            make.width.equalTo(Constants.BackButton.heightWight)
        }

        inputFieldsStack.snp.makeConstraints { make in
            make.top.equalTo(registrationLabel.snp.bottom)
                .offset(Constants.TextFieldsStack.topOffset)
            make.leading.trailing.equalToSuperview()
                .inset(Constants.TextFieldsStack.leadingInset)
            make.height.equalTo(Constants.TextFieldsStack.height)
        }

        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(Constants.RegisterButton.bottomOffset)
            make.height.equalTo(Constants.RegisterButton.height)
            make.leading.equalToSuperview()
                .offset(Constants.RegisterButton.leadingOffset)
            make.trailing.equalToSuperview()
                .offset(Constants.RegisterButton.trailingOffset)
        }
        
        privatePolicyLabelTap.snp.makeConstraints { make in
            make.width.equalTo(registrationButton.snp.width)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(registrationButton.snp.top)
                .offset(Constants.PrivatePolicyLabelTap.bottomoffset)
        }
        
        privatePolicyLabel.snp.makeConstraints { make in
            make.width.equalTo(registrationButton.snp.width)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(privatePolicyLabelTap.snp.top)
        }
    }
    @objc
    private func backAction() {
        // TODO: - дописать метод перехода обратно
    }
    
    @objc
    private func changeEmail(_ textField: UITextField) {
        viewModel.changeUserEmail(textField.text ?? "")
    }
    
    @objc
    private func changePassword(_ textField: UITextField) {
        viewModel.changePassword(textField.text ?? "")
    }
    
    @objc
    private func policyAction() {
        // Настроить переход на экран условия и политики конфиденсиальности
        print("tap Policy")
    }
    
    @objc private func registerAction() {
        viewModel.didTapLoginButton()
    }
    
    private enum Constants {
        enum View {
            static let cornerRadius: CGFloat = 12
        }
        enum EntryLabel {
            static let topOffset: CGFloat = 32
        }
        enum BackButton {
            static let leadingOffset: CGFloat = 16
            static let heightWight: CGFloat = 24
        }
        enum TextFieldsStack {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 20
            static let leadingInset: CGFloat = 16
            static let height: CGFloat = 158
        }
        enum RegisterButton {
            static let bottomOffset: CGFloat = -11
            static let height: CGFloat = 51
            static let leadingOffset: CGFloat = 16
            static let trailingOffset: CGFloat = -16
        }
        enum PrivatePolicyLabelTap {
            static let bottomoffset: CGFloat = -12
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

