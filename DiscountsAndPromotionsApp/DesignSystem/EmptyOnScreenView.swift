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
            return UIImage.noFavorites
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.text = NSLocalizedString("No Favorites Description", tableName: "MainFlow", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
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
        backgroundColor = .cherryWhite
        
        [emptyCherryImageView, titleLabel, mainButton].forEach { addSubview($0) }
        
        switch state {
        case .noResult:
            addSubview(mainButton)
            
            emptyCherryImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(238)
                make.height.equalTo(271)
                make.top.equalToSuperview().inset(179)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(emptyCherryImageView.snp.bottom).inset(-47)
            }
            
            mainButton.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(51)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        case .noFavorites:
            addSubview(descriptionLabel)
            
            emptyCherryImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview().inset(2)
                make.top.equalToSuperview().inset(260)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(emptyCherryImageView.snp.bottom).inset(-50)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).inset(-11)
                make.leading.trailing.equalTo(titleLabel)
            }
        }
    }
}
