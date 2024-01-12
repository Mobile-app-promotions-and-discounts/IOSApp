import UIKit
import SnapKit
import Combine

enum EmptyViewState {
    case noResult
    case noFavorites

    var image: UIImage {
        switch self {
        case .noResult:
            return UIImage.emptyCherry
        case .noFavorites:
            return UIImage.emptyCherry
        }
    }

    var title: String {
        switch self {
        case .noResult:
            return NSLocalizedString("Nothing found", tableName: "MainFlow", comment: "")
        case .noFavorites:
            return NSLocalizedString("No favorites", tableName: "MainFlow", comment: "")

        }
    }
}

final class EmptyOnScreenView: UIView {
    let mainButtonTappedPublisher = PassthroughSubject<Void, Never>()

    private let state: EmptyViewState

    private let emptyCherryImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerLarge
        label.textAlignment = .center
        return label
    }()

    private lazy var mainButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(NSLocalizedString("Return to Main", tableName: "MainFlow", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        return button
    }()

    init(state: EmptyViewState) {
        self.state = state
        super.init(frame: .zero)
        configure(for: state)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func mainButtonTapped() {
        mainButtonTappedPublisher.send(())
    }

    private func configure(for state: EmptyViewState) {
        emptyCherryImageView.image = state.image
        titleLabel.text = state.title
    }

    private func setupViews() {
        [emptyCherryImageView, titleLabel, mainButton].forEach { addSubview($0) }

        emptyCherryImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(emptyCherryImageView.snp.bottom).inset(17)
        }

        // Проверяем состояние и добавляем кнопку, если состояние не noFavorites
        if state != .noFavorites {
            addSubview(mainButton)
            mainButton.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(51)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
