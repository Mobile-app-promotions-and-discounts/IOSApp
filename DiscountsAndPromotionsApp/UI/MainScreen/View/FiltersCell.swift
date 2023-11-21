import UIKit
import SnapKit

class FiltersCell: UICollectionViewCell {
    static let reuseIdentifier = "FiltersCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cellTitle: UILabel = {
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

        contentView.backgroundColor = UIColor.filterCellBG
        contentView.layer.cornerRadius = 15

        cellTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
