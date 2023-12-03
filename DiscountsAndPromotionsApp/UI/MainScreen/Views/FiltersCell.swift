import UIKit
import SnapKit

final class FiltersCell: UICollectionViewCell {
    static let reuseIdentifier = "FiltersCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var cellTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .medium)
        title.numberOfLines = 1
        return title
    }()

    func configure(with title: String) {
        self.cellTitle.text = title
    }

    private func setupViews() {
        contentView.addSubview(cellTitle)

        contentView.backgroundColor = UIColor.cherryWhite
        contentView.layer.cornerRadius = 20

        cellTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
