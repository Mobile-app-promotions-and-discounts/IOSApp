import Combine
import SnapKit
import UIKit

final class TouchRatingView: UIView {

    // MARK: - Public properties
    var rating: CurrentValueSubject<Int,Never>
    let maxRating: Int

    // MARK: - Private properies
    private lazy var buttons: [UIButton] = []

    private lazy var buttonsStackView: UIStackView = {
        for i in 1...maxRating {
            let image = checkImage(currentIndex: i)
            let button = UIButton()
            button.setImage(image, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = Const.spacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    // MARK: - Lifecicle
    init(rating: Int, maxRating: Int) {
        self.rating = CurrentValueSubject(rating)
        self.maxRating = maxRating
        super .init(frame: CGRect())
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func checkImage(currentIndex: Int) -> UIImage {
        currentIndex <= rating.value ? .icBigStarFill : .icBigStar
    }

    @objc private func touchButton(_ sender: UIButton) {
        self.rating.send(sender.tag)
        redrawButtons()
    }

    private func redrawButtons() {
        buttons.forEach { $0.setImage(checkImage(currentIndex: $0.tag),
                                      for: .normal)}
    }

    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(buttonsStackView)

        self.snp.makeConstraints {
            $0.width.equalTo(Const.width)
            $0.height.equalTo(Const.height)
        }

        buttonsStackView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }

    // MARK: - Constants
    private enum Const {
        static let width: CGFloat = 128
        static let height: CGFloat = 24
        static let spacing: CGFloat = 2
    }

}
