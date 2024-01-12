import Kingfisher
import SnapKit
import UIKit

final class GalleryPageViewController: UIViewController {
    var imageURL: URL? {
        didSet {
            loadImage()
        }
    }
    var pageIndex: Int?
    private let imageView = UIImageView()

    override func viewDidLoad() {
        setupUI()
    }

    private func setupUI() {
        view.addSubview(imageView)
        imageView.backgroundColor = .clear
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFit
    }

    private func loadImage() {
        imageView.kf.setImage(with: imageURL)
    }
}
