import UIKit
import SnapKit

final class InputUserDataField: UIView {

    private let textFieldDelegate: UITextFieldDelegate

    var titleLabelText: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var textField: UITextField {
        inputDataTextField.self
    }

    var text: String? {
        inputDataTextField.text
    }

    var placeholder: String? {
        get {
            inputDataTextField.placeholder
        }
        set {
            inputDataTextField.placeholder = newValue
        }
    }

    var isShowHidePasswordButtonVisible: Bool {
        get {
            inputDataTextField.rightView != nil && inputDataTextField.rightViewMode == .always
        }
        set {
            newValue == true ? showPasswordButton() : hidePasswordButton()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var inputDataTextField: UITextField = {
        let textField = UITextField()
        textField.font = CherryFonts.textMedium
        textField.textColor = .cherryGrayBlue
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.cherryGrayBlue.cgColor
        textField.delegate = textFieldDelegate
        textField.makeIndent(points: 12)
        return textField
    }()

    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        button.setImage(.icEyeOpen, for: .normal)
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        return button
    }()

    init(frame: CGRect = .zero, textFieldDelegate: UITextFieldDelegate) {
        self.textFieldDelegate = textFieldDelegate
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        [titleLabel, inputDataTextField].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        inputDataTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
    }

    private func showPasswordButton() {
        inputDataTextField.isSecureTextEntry = true
        inputDataTextField.rightViewMode = .always
        inputDataTextField.rightView = showHidePasswordButton
    }

    private func hidePasswordButton() {
        inputDataTextField.isSecureTextEntry = false
        inputDataTextField.rightViewMode = .never
        inputDataTextField.rightView = nil
    }

    @objc private func showHidePassword() {
        inputDataTextField.isSecureTextEntry.toggle()
        showHidePasswordButton.setImage(inputDataTextField.isSecureTextEntry ? .icEyeOpen : .icEyeClosed, for: .normal)
    }
}
