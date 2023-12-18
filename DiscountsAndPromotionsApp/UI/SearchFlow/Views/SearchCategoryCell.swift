import UIKit

final class SearchCategoryCell: UITableViewCell {
    private (set) var category: Category?
    static let reuseIdentiffier = "SearchCategoryCell"

    private lazy var backdropView = {
        let view = UIView()
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.clipsToBounds = true
        return view
    }()
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerSmall
        return label
    }()
    private lazy var categoryIconView: UIImageView = {
        UIImageView()
    }()

    func setUpCell(with searchCategory: SearchCategory) {
        category = Category(name: searchCategory.rawValue, image: "")
        categoryIconView.image = searchCategory.getIcon()
        categoryNameLabel.text = searchCategory.rawValue

        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        [backdropView, categoryIconView, categoryNameLabel].forEach {
            addSubview($0)
        }

        categoryIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.leading.equalToSuperview().offset(12)
        }
        categoryNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryIconView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
        }
        backdropView.snp.removeConstraints()
        backdropView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    override func prepareForReuse() {
        categoryNameLabel.removeFromSuperview()
        categoryIconView.removeFromSuperview()
        super.prepareForReuse()
    }
}
