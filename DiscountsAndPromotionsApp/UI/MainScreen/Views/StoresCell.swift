import UIKit
import SnapKit

final class StoresCell: UICollectionViewCell {
    static let reuseIdentifier = "StoresCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cherryGrayBlue
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    private lazy var offersCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var nameAndOffersStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, offersCountLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    func configure(with store: StoreUIModel) {
        self.nameLabel.text = store.name
        self.offersCountLabel.text = "\(store.offersCount) предложений"
        self.distanceLabel.text = "\(store.distance) м"
    }

    private func setupViews() {
        contentView.backgroundColor = UIColor.cherryWhite
        contentView.layer.cornerRadius = 20

        [storeImageView, nameAndOffersStackView, distanceLabel].forEach { contentView.addSubview($0) }

        storeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(148)
        }

        nameAndOffersStackView.snp.makeConstraints { make in
            make.top.equalTo(storeImageView.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(storeImageView)
        }

        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAndOffersStackView)
            make.trailing.equalTo(storeImageView.snp.trailing)
        }
    }
}
