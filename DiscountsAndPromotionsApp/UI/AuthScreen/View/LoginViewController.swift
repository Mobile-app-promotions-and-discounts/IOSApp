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
        stackView.spacing = 8
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
        let button = UIButton()
        button.setTitle(L10n.Authorization.loginTitle, for: .normal)
        button.setTitleColor(.cherryWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = CherryFonts.headerMedium
        button.backgroundColor = .cherryMainAccent
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Authorization.registerTitle, for: .normal)
        button.setTitleColor(.cherryMainAccent, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = CherryFonts.headerMedium
        button.backgroundColor = .cherryWhite
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.cherryMainAccent.cgColor
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
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
        view.layer.cornerRadius = 12
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
            make.top.equalToSuperview().offset(32)
        }

        inputFieldsStack.snp.makeConstraints { make in
            make.top.equalTo(entryLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(158)
        }

        passwordRecoveryButton.snp.makeConstraints { make in
            make.top.equalTo(inputFieldsStack.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(19)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(11)
            make.height.equalTo(106)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
