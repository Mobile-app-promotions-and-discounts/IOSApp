import SnapKit
import UIKit

final class ReviewTextView: UIView {

    // MARK: - Public properties
    var text: String

    // MARK: - Private properties
    private var delegate: UITextViewDelegate
    private var buttonHandler: () -> Void

    // MARK: - Layout properties
    private lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = delegate
        textView.text = text
        textView.font = CherryFonts.textMedium
        textView.textColor = .cherryBlack
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        return textView
    }()

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(.icAttach, for: .normal)
        button.tintColor = .cherryBlueGray
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecicle
    init(delegate: UITextViewDelegate,
         text: String,
         buttonHandler: @escaping () -> Void) {
        self.delegate = delegate
        self.text = text
        self.buttonHandler = buttonHandler
        super .init(frame: CGRect())
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    @objc
    private func buttonAction() {
        buttonHandler()
    }

    private func setupView() {
        self.backgroundColor = .cherryLightBlue

        self.addSubview(reviewTextView)
        self.addSubview(addPhotoButton)

        reviewTextView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
                .inset(Const.inset)
            $0.trailing.equalTo(addPhotoButton.snp.leading)
        }

        addPhotoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
                .inset(Const.inset)
            $0.width.height.equalTo(Const.Button.heightWidth)
        }

    }

    private enum Const {
        static let inset: CGFloat = 8
        enum Button {
            static let heightWidth: CGFloat = 24
        }

    }

}
