import UIKit
import SnapKit
import Combine

final class LoginViewController: UIViewController {

    weak var coordinator: MainCoordinator?

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
        return field
    }()

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Authorization.passwordTitle
        field.placeholder = "cherryapp"
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

    private lazy var passwordRecoveryButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Authorization.forgotPasswordTitle, for: .normal)
        button.setTitleColor(.cherryGrayBlue, for: .normal)
        button.titleLabel?.font = CherryFonts.textMedium
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
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.ButtonStack.spacing
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
        setupBindings()
    }

    private func setupBindings() {
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
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Constants.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @objc private func loginAction() {
        let userEmail = inputEmailField.text
        let userPassword = inputPasswordField.text
        viewModel.didTapLoginButton(userEmail: userEmail, userPassword: userPassword)
    }

    private func setupConstraints() {
        [entryLabel, inputFieldsStack, passwordRecoveryButton, buttonsStackView].forEach { view.addSubview($0) }

        entryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.EntryLabel.topOffset)
        }

        inputFieldsStack.snp.makeConstraints { make in
            make.top.equalTo(entryLabel.snp.bottom).offset(Constants.TextFieldsStack.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.TextFieldsStack.leadingInset)
            make.height.equalTo(Constants.TextFieldsStack.height)
        }

        passwordRecoveryButton.snp.makeConstraints { make in
            make.top.equalTo(inputFieldsStack.snp.bottom).offset(Constants.PasswordButtom.topOffset)
            make.leading.equalToSuperview().offset(Constants.PasswordButtom.leadingOffset)
            make.height.equalTo(Constants.PasswordButtom.height)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.ButtonStack.leadingInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.ButtonStack.bottomInset)
            make.height.equalTo(Constants.ButtonStack.height)
        }
    }
    
    private enum Constants {
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
}
