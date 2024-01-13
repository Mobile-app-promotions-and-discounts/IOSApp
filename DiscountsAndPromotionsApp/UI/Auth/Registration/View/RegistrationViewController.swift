import Combine
import SnapKit
import UIKit

final class RegistrationViewController: UIViewController {

    weak var coordinator: AuthCoordinator?

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
        view.layer.cornerRadius = Const.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupConstraints() {
        [registrationLabel,
         backButton,
         inputFieldsStack,
         privatePolicyLabel,
         privatePolicyLabelTap,
         registrationButton].forEach { view.addSubview($0) }

        registrationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
                .offset(Const.EntryLabel.topOffset)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(registrationLabel.snp.centerY)
            $0.leading.equalToSuperview()
                .offset(Const.BackButton.leadingOffset)
            $0.height.equalTo(Const.BackButton.heightWight)
            $0.width.equalTo(Const.BackButton.heightWight)
        }

        inputFieldsStack.snp.makeConstraints {
            $0.top.equalTo(registrationLabel.snp.bottom)
                .offset(Const.TextFieldsStack.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextFieldsStack.leadingInset)
            $0.height.equalTo(Const.TextFieldsStack.height)
        }

        registrationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(Const.RegisterButton.bottomOffset)
            $0.height.equalTo(Const.RegisterButton.height)
            $0.leading.equalToSuperview()
                .offset(Const.RegisterButton.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.RegisterButton.trailingOffset)
        }
        
        privatePolicyLabelTap.snp.makeConstraints {
            $0.width.equalTo(registrationButton.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(registrationButton.snp.top)
                .offset(Const.PrivatePolicyLabelTap.bottomoffset)
        }
        
        privatePolicyLabel.snp.makeConstraints {
            $0.width.equalTo(registrationButton.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privatePolicyLabelTap.snp.top)
        }
    }
    
    @objc
    private func backAction() {
        dismiss(animated: true)
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
        coordinator?.navigateToSuccessScreen(from: self)
    }
    
    private enum Const {
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

// MARK: - UIViewControllerTransitioningDelegate

extension RegistrationViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PartialSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
