import Combine
import UIKit

class RecoveryEndViewController: UIViewController {
    
    weak var coordinator: AuthCoordinator?
    private let viewModel: RecoveryEndViewModelProtocol
    private var cancellables: Set<AnyCancellable>
    
    private lazy var recoveryLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.RecoveryEnd.title
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
        //TODO: -
    }
    
    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Const.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupConstraints() {
        [recoveryLabel,
         backButton,
         inputPasswordField,
         signButton].forEach { view.addSubview($0) }

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

        inputPasswordField.snp.makeConstraints {
            $0.top.equalTo(recoveryLabel.snp.bottom)
                .offset(Const.TextField.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.TextField.leadingInset)
            $0.height.equalTo(Const.TextField.height)
        }

        signButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
                .offset(Const.SignButton.bottomOffset)
            $0.height.equalTo(Const.SignButton.height)
            $0.leading.equalToSuperview()
                .offset(Const.SignButton.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.SignButton.trailingOffset)
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
        enum TextField {
            static let topOffset: CGFloat = 20
            static let leadingInset: CGFloat = 16
            static let height: CGFloat = 75
        }
        enum SignButton {
            static let bottomOffset: CGFloat = -24
            static let height: CGFloat = 51
            static let leadingOffset: CGFloat = 16
            static let trailingOffset: CGFloat = -16
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
