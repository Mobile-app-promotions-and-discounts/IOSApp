import Combine
import UIKit

class RecoveryEndViewController: AuthParentViewController {

    private let viewModel: RecoveryEndViewModelProtocol
    private var cancellables: Set<AnyCancellable>

    private lazy var inputPasswordField: InputUserDataField = {
        let field = InputUserDataField(textFieldDelegate: self)
        field.titleLabelText = L10n.RecoveryEnd.newPassword
        field.placeholder = "cherryapp"
        field.textField.addTarget(self, action: #selector(changePassword(_:)), for: .editingChanged)
        field.isShowHidePasswordButtonVisible = true
        return field
    }()

    private lazy var signButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.RecoveryEnd.sign, for: .normal)
        button.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        return button
    }()

    init(viewModel: RecoveryEndViewModelProtocol) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()
        super.init(title: L10n.RecoveryEnd.title,
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
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }

    private func bindingOn() {
        viewModel.passwordIsNoEmpty
            .receive(on: DispatchQueue.main)
            .assign(to: \.isUserInteractionEnabled, on: signButton)
            .store(in: &cancellables)
    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    @objc private func backAction() {
        coordinator?.popToNavigate()
    }

    @objc private func changePassword(_ textField: UITextField) {
        let text = textField.text ?? ""
        viewModel.changePassword(text)
    }

    @objc private func signAction() {
        // TODO: -
    }

    private func backButtonAction() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    private func setupConstraints() {
        [inputPasswordField,
         signButton].forEach { view.addSubview($0) }

        inputPasswordField.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(Const.TextField.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextField.horizontalInset)
            $0.height.equalTo(Const.TextField.height)
        }

        signButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
                .offset(Const.SignButton.bottomOffset)
            $0.height.equalTo(Const.SignButton.height)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.SignButton.horizontalInset)
        }

    }

    private enum Const {
        enum TextField {
            static let topOffset: CGFloat = 112
            static let horizontalInset: CGFloat = 16
            static let height: CGFloat = 75
        }
        enum SignButton {
            static let bottomOffset: CGFloat = -24
            static let height: CGFloat = 51
            static let horizontalInset: CGFloat = 16
        }
    }

}

extension RecoveryEndViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
