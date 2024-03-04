import Combine
import SnapKit
import UIKit

final class RegistrationViewController: AuthParentViewController {
    private enum Const {
        enum TextFieldsStack {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 82
            static let horizontalInset: CGFloat = 16
            static let height: CGFloat = 158
        }
        enum RegisterButton {
            static let bottomInset: CGFloat = 24
            static let height: CGFloat = 51
            static let horizontalInset: CGFloat = 16
        }
        enum PrivatePolicyLabelTap {
            static let bottomOffset: CGFloat = -12
        }
    }

    private let viewModel: RegistrationViewModelProtocol
    private var cancellables: Set<AnyCancellable>

    private lazy var inputEmailField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Registration.emailTitle
        field.textField.addTarget(self, action: #selector(changeEmail(_:)), for: .editingChanged)
        return field
    }()

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.Registration.passwordTitle
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
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var registrationButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.Registration.registrationTitle, for: .normal)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return button
    }()

    init(viewModel: RegistrationViewModelProtocol) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()
        super.init(title: L10n.Registration.entryTitle,
                   isAddBackButton: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonAction()
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
        viewModel.validToSubmit
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: registrationButton)
            .store(in: &cancellables)

        viewModel.isUserAuthorizatedUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAutorizated in
                if isAutorizated {
                    self?.navigateToSuccessScreen()
                } else {
                    ErrorHandler.handle(error: .authError)
                }
            }.store(in: &cancellables)
    }

    private func backButtonAction() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    private func setupConstraints() {
        [inputFieldsStack,
         privatePolicyLabel,
         registrationButton,
         privatePolicyLabelTap].forEach { view.addSubview($0) }

        inputFieldsStack.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(Const.TextFieldsStack.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextFieldsStack.horizontalInset)
            $0.height.equalTo(Const.TextFieldsStack.height)
        }

        registrationButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
                .inset(Const.RegisterButton.bottomInset)
            $0.height.equalTo(Const.RegisterButton.height)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.RegisterButton.horizontalInset)
        }

        privatePolicyLabelTap.snp.makeConstraints {
            $0.width.equalTo(registrationButton.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(registrationButton.snp.top)
                .offset(Const.PrivatePolicyLabelTap.bottomOffset)
        }

        privatePolicyLabel.snp.makeConstraints {
            $0.width.equalTo(registrationButton.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privatePolicyLabelTap.snp.top)
        }
    }

    private func navigateToSuccessScreen() {
        coordinator?.navigateToSuccessScreen()
    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    @objc
    private func backAction() {
        coordinator?.popToNavigate()
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
        coordinator?.navigateToPrivacyWebView(from: self)
    }

    @objc private func registerAction() {
        viewModel.didTapLoginButton()
    }

    private func configureApperance() {
        view.backgroundColor = .cherryWhiteEmptyScreen
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
