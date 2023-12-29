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
        textField.textColor = .cherryBlack
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.borderWidth = Constants.TextField.borderWidth
        textField.layer.borderColor = UIColor.cherryGrayBlue.cgColor
        textField.delegate = textFieldDelegate
        textField.makeIndent(points: Constants.TextField.makeIndent)
        return textField
    }()

    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: Constants.Button.widthHeidth,
                                                                        height: Constants.Button.widthHeidth)))
        button.setImage(.icEyeOpen, for: .normal)
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: Constants.Button.Insets.top,
                                              left: Constants.Button.Insets.left,
                                              bottom: Constants.Button.Insets.bottom,
                                              right: Constants.Button.Insets.right)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.TextField.topOffset)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(Constants.TextField.height)
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
    
    private enum Constants {
        enum TextField {
            static let cornerRadius: CGFloat = 10
            static let borderWidth: CGFloat =  1
            static let makeIndent: CGFloat = 12
            static let height: CGFloat = 52
            static let topOffset: CGFloat = 4
        }
        enum Button {
            static let widthHeidth: CGFloat = 20
            enum Insets {
                static let top: CGFloat = 0
                static let left: CGFloat = -16
                static let bottom: CGFloat = 0
                static let right: CGFloat = 0
            }
        }
    }
}
