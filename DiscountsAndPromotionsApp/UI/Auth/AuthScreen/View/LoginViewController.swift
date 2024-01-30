import UIKit
import SnapKit
import Combine

final class LoginViewController: UIViewController {

    weak var coordinator: AuthCoordinator?

    private let viewModel: LoginViewModelProtocol

    private var cancellables: Set<AnyCancellable>
    
    private lazy var entryLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.entryTitle
        label.font = CherryFonts.titleExtraLarge
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var inputEmailField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Authorization.emailTitle
        field.placeholder = "ivanov@example.com"
        field.textField.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        return field
    }()

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Authorization.passwordTitle
        field.placeholder = "cherryapp"
        field.textField.addTarget(self, action: #selector(changePassword(_:)), for: .editingChanged)
        field.isShowHidePasswordButtonVisible = true
        return field
    }()

    private lazy var inputFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [inputEmailField, inputPasswordField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Const.TextFieldsStack.spacing
        return stackView
    }()

    private lazy var passwordRecoveryButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Authorization.forgotPasswordTitle, for: .normal)
        button.setTitleColor(.cherryBlue, for: .normal)
        button.titleLabel?.font = CherryFonts.textMedium
        button.addTarget(self, action: #selector(navigateToRecoveryScreen), for: .touchUpInside)
        return button
    }()

    private lazy var loginButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.Authorization.loginTitle, for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = SecondaryButton()
        button.setTitle(L10n.Authorization.registerTitle, for: .normal)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Const.ButtonStack.spacing
        return stackView
    }()

    init(viewModel: LoginViewModelProtocol = LoginViewModel()) {
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
        viewModel.isUserAuthorizedUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] isAuthorized in
                if isAuthorized {
                    self?.dismiss(animated: true)
                    self?.coordinator?.navigateToMainScreen()
                } else {
                    ErrorHandler.handle(error: .authorizationError)
                }
            }.store(in: &cancellables)
        
        viewModel.validToSubmit
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: loginButton)
            .store(in: &cancellables)
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Const.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc private func navigateToRecoveryScreen() {
        coordinator?.navigateToRecoveryStartScreen()
    }

    @objc private func loginAction() {
        viewModel.didTapLoginButton()
    }
    
    @objc private func registerAction() {
        coordinator?.navigateToRegistrationScreen()
    }
    
    @objc private func changeEmail(_ textField: UITextField) {
        viewModel.changeUserEmail(textField.text ?? "")
    }
    
    @objc private func changePassword(_ textField: UITextField) {
        viewModel.changePassword(textField.text ?? "")
    }
    
    private func bindingOff() {
        viewModel.bindingOff()
        cancellables.removeAll()
    }
    
    private func setupConstraints() {
        [entryLabel,
         inputFieldsStack,
         passwordRecoveryButton,
         buttonsStackView].forEach { view.addSubview($0) }

        entryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
                .offset(Const.EntryLabel.topOffset)
        }

        inputFieldsStack.snp.makeConstraints {
            $0.top.equalTo(entryLabel.snp.bottom)
                .offset(Const.TextFieldsStack.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextFieldsStack.leadingInset)
            $0.height.equalTo(Const.TextFieldsStack.height)
        }

        passwordRecoveryButton.snp.makeConstraints {
            $0.top.equalTo(inputFieldsStack.snp.bottom)
                .offset(Const.PasswordButtom.topOffset)
            $0.leading.equalToSuperview()
                .offset(Const.PasswordButtom.leadingOffset)
            $0.height.equalTo(Const.PasswordButtom.height)
        }

        buttonsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(Const.ButtonStack.leadingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Const.ButtonStack.bottomInset)
            $0.height.equalTo(Const.ButtonStack.height)
        }
    }
    
    private enum Const {
        enum View {
            static let cornerRadius: CGFloat = 12
        }
        enum TextFieldsStack {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 20
            static let leadingInset: CGFloat = 16
            static let height: CGFloat = 158
        }
        enum ButtonStack {
            static let spacing: CGFloat = 4
            static let leadingInset: CGFloat = 16
            static let bottomInset: CGFloat = 11
            static let height: CGFloat = 106
        }
        enum EntryLabel {
            static let topOffset: CGFloat = 32
        }
        enum PasswordButtom {
            static let topOffset: CGFloat = 4
            static let leadingOffset: CGFloat = 16
            static let height: CGFloat = 19
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
