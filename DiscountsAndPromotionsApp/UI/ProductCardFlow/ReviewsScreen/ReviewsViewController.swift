import Combine
import UIKit

final class ReviewsViewController: CherryCustomViewController {
    private let insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    private var viewModel: ProductCardViewModel

    private lazy var reviewsTable = {
        let table = UITableView()

        return table
    }()

    init(viewModel: ProductCardViewModel) {
        self.viewModel = viewModel
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
        navigationItem.title = viewModel.product?.name ?? "Отзывы"

        setupTable()
    }

    private func setupTable() {
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        reviewsTable.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.reuseIdentifier)
        reviewsTable.register(ReviewRatingHeader.self, forHeaderFooterViewReuseIdentifier: ReviewRatingHeader.reuseIdentifier)

        view.addSubview(reviewsTable)
        reviewsTable.layer.cornerRadius = CornerRadius.regular.cgFloat()
        reviewsTable.separatorStyle = .none
        reviewsTable.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide).inset(insets)
        }
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as? ReviewCell else { return UITableViewCell() }
        cell.configure(for: ProductReviewModel(user: "BoSS", text: "YO", score: 5))
        return cell
    }

}
