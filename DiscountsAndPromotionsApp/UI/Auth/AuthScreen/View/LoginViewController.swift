import UIKit
import SnapKit
import Combine

final class LoginViewController: AuthParentViewController {
    private enum Const {
        enum TextFieldsStack {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 82
            static let horizontalInset: CGFloat = 16
            static let height: CGFloat = 158
        }
        enum ButtonStack {
            static let spacing: CGFloat = 4
            static let horizontalInset: CGFloat = 16
            static let bottomInset: CGFloat = 24
            static let height: CGFloat = 106
        }
        enum PasswordButtom {
            static let topOffset: CGFloat = 4
            static let leadingOffset: CGFloat = 16
            static let height: CGFloat = 19
        }
    }

    private let viewModel: LoginViewModelProtocol
    private var cancellables: Set<AnyCancellable>

    private lazy var inputEmailField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Authorization.emailTitle
        field.textField.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        return field
    }()

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Authorization.passwordTitle
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
        super.init(title: L10n.Authorization.entryTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
        bindingOff()
    }

    private func bindingOn() {
        viewModel.isUserAuthorizedUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] isAuthorized in
                self?.isNavigateToMainScreen(isAuthorized)
            }.store(in: &cancellables)

        viewModel.validToSubmit
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: loginButton)
            .store(in: &cancellables)
    }

    private func isNavigateToMainScreen(_ isAuthorized: Bool) {
        if isAuthorized {
            coordinator?.dismissVC(self)
            coordinator?.navigateToMainScreen()
        }
    }

    @objc private func navigateToRecoveryScreen() {
        if viewModel.checkUserEmail() {
            coordinator?.navigateToRecoveryStartScreen()
        } else {
            ErrorHandler.handle(error: .customError(L10n.RecoveryStart.recoveryError))
        }
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
        cancellables.removeAll()
    }

    private func setupConstraints() {
        [inputFieldsStack,
         passwordRecoveryButton,
         buttonsStackView].forEach { view.addSubview($0) }

        inputFieldsStack.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(Const.TextFieldsStack.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextFieldsStack.horizontalInset)
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
                .inset(Const.ButtonStack.horizontalInset)
            $0.bottom.equalToSuperview()
                .inset(Const.ButtonStack.bottomInset)
            $0.height.equalTo(Const.ButtonStack.height)
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
