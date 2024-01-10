import Combine
import UIKit

final class ReviewsViewController: UIViewController {
    private let product: Product?
    private var reviewCount: Int

    init(product: Product?, reviewCount: Int) {
        self.product = product
        self.reviewCount = reviewCount

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .cherryLightBlue
        navigationItem.title = product?.name ?? "Отзывы"

    }
}
