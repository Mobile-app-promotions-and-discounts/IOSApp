import UIKit
import SnapKit

final class StoresCell: UICollectionViewCell {
    static let reuseIdentifier = "StoresCell"

    private lazy var storeImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with store: StoreUIModel) {
        guard let imageString = store.image else {
            ErrorHandler.handle(error: .customError("Ошибка получения фото для ячейки раздела Магазин"))
            return
        }
        self.storeImageView.image = UIImage(named: imageString)
    }

    private func setupViews() {
        contentView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.cherryLightBlue.cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = .cherryLightBlue
        contentView.addSubview(storeImageView)

        storeImageView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
    }
}
