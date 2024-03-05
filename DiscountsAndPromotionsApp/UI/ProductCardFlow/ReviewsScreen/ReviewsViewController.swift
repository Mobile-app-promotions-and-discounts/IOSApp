import Combine
import UIKit

final class ReviewsViewController: CherryCustomViewController {
    weak var coordinator: ProductCardEnabledCoordinatorProtocol?

    private let insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    private var viewModel: ProductCardViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var reviewsTable = {
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = UIColor.cherryWhite
        return table
    }()

    private lazy var reviewButton = {
        let button = PrimaryButton(type: .custom)
        button.setTitle(NSLocalizedString("NewReview", tableName: "ProductFlow", comment: ""), for: .normal)
        return button
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
//        navigationItem.title = viewModel.product?.name ?? NSLocalizedString("Reviews",
//                                                                            tableName: "ProductFlow",
//                                                                            comment: "")
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        reviewsTable.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.reuseIdentifier)
//        reviewsTable.register(ReviewRatingHeader.self, forHeaderFooterViewReuseIdentifier: ReviewRatingHeader.reuseIdentifier)

        view.addSubview(reviewButton)
        reviewButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(insets)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(51)
        }

        view.addSubview(reviewsTable)
        reviewsTable.layer.cornerRadius = CornerRadius.regular.cgFloat()
        reviewsTable.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(insets)
            make.bottom.equalTo(reviewButton.snp.top).offset(-insets.bottom)
        }
    }

    private func setupBindings() {
        reviewButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showModalReviewController(viewModel: self.viewModel)
            }
            .store(in: &cancellables)
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        viewModel.reviews.count
        10
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        56
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewRatingHeader.reuseIdentifier) as? ReviewRatingHeader,
//////              let product = viewModel.product else { return nil }
//////        header.configureFor(rating: product.rating ?? 0, reviewCount: viewModel.reviews.count)
////        return header
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as? ReviewCell else { return UITableViewCell() }
//        cell.configure(for: viewModel.reviews[indexPath.row])
        return cell
    }
}
