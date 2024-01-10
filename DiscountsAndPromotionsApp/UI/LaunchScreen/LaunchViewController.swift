import UIKit
import SnapKit

final class LaunchViewController: UIViewController {

    private let cherryImageView: UIImageView = {
        let imageView = UIImageView(image: .cherryLogo)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Черри", tableName: "LaunchFlow", comment: "")
        label.font = CherryFonts.logoText
        label.textColor = .cherryLogo
        label.textAlignment = .left
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Акции и скидки каждый день", tableName: "LaunchFlow", comment: "")
        label.font = CherryFonts.textLarge
        label.numberOfLines = 2
        label.textColor = .cherryLogo
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .cherryWhite
        [cherryImageView, nameLabel, taglineLabel].forEach { view.addSubview($0) }

        cherryImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(180)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(cherryImageView.snp.leading)
            make.top.equalTo(cherryImageView.snp.bottom).inset(-42)
        }

        taglineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(79)
            make.top.equalTo(nameLabel.snp.bottom).inset(-12)
        }
    }
}
