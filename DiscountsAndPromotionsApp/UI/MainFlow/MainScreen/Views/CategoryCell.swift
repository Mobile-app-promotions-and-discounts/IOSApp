import UIKit
import Kingfisher
import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.categoryImageView.image = nil
    }

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var cellTitle: UILabel = {
        let title = UILabel()
        title.textColor = .cherryBlack
        title.font = CherryFonts.headerSmall
        title.textAlignment = .center
        return title
    }()

    func configure(with model: CategoryUIModel) {
        if let imageURL = URL(string: model.image ?? "") {
            categoryImageView.kf.setImage(with: imageURL,
                                          options: [
                                                .transition(ImageTransition.fade(0.3))])
        } else {
            categoryImageView.image = UIImage(systemName: "circle.fill")
        }
        self.cellTitle.text = model.title
    }

    private func setupViews() {
        contentView.backgroundColor = UIColor.cherryWhite
        contentView.layer.cornerRadius = CornerRadius.large.cgFloat()

        [cellTitle, categoryImageView].forEach { contentView.addSubview($0) }

        cellTitle.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(4)
        }

        categoryImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(cellTitle.snp.top).inset(-6)
        }

    }
}
