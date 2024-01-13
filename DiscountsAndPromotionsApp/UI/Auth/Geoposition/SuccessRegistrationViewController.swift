import UIKit

final class SuccessRegistrationViewController: UIViewController {
    
    weak var coordinator: AuthCoordinator?
    
    private lazy var cherryImageView: UIImageView = {
        let image = UIImage(named: "cherryHi") ?? UIImage()
        return UIImageView(image: image)
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Location.welcome
        label.font = CherryFonts.titleExtraLarge
        label.textColor = .cherryBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var enterCityLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Location.enterCity
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var automaticButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.Location.automatical, for: .normal)
        button.addTarget(self, action: #selector(automaticLocationAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var manualButton: UIButton = {
        let button = SecondaryButton()
        button.setTitle(L10n.Location.manual, for: .normal)
        button.addTarget(self, action: #selector(manuallyLocationAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [automaticButton, manualButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = Const.View.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc private func automaticLocationAction() {
        // TODO: Следующий спринт
    }
    
    @objc private func manuallyLocationAction() {
        // TODO: Следующий спринт
    }
    
    private func setupConstraints() {
        [cherryImageView,
         welcomeLabel,
         enterCityLabel,
         buttonsStackView].forEach { view.addSubview($0) }
        
        cherryImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
                .offset(Const.ImageView.topOffset)
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cherryImageView.snp.bottom)
                .offset(Const.Welcome.topOffset)
        }
        
        enterCityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview()
                .offset(Const.EntryCity.leadingOffset)
            $0.trailing.equalToSuperview()
                .offset(Const.EntryCity.trailingOffset)
            $0.top.equalTo(welcomeLabel.snp.bottom)
                .offset(Const.EntryCity.topOffset)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(Const.ButtonStack.leadingInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                .inset(Const.ButtonStack.bottomInset)
            $0.height.equalTo(Const.ButtonStack.height)
        }
    }
    
    private enum Const {
        enum View {
            static let cornerRadius: CGFloat = 12
        }
        enum ImageView {
            static let topOffset: CGFloat = 17
        }
        enum Welcome {
            static let topOffset: CGFloat = 25
        }
        enum EntryCity {
            static let topOffset: CGFloat = 20
            static let leadingOffset: CGFloat = 42
            static let trailingOffset: CGFloat = -42
        }
        enum ButtonStack {
            static let spacing: CGFloat = 4
            static let leadingInset: CGFloat = 16
            static let bottomInset: CGFloat = 11
            static let height: CGFloat = 106
        }
    }
}
