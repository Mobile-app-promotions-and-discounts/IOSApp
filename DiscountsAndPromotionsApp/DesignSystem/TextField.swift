import UIKit

final class TextField: UITextField {

    var insets: UIEdgeInsets = UIEdgeInsets()

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.backgroundColor = .cherryWhite
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.font = CherryFonts.headerMedium
        self.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [
            .foregroundColor: UIColor.cherryGrayBlue,
            .font: CherryFonts.textMedium as Any
        ])
        self.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       deleteAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .trash:
                    return deleteAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)

            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .inline
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .trash),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
