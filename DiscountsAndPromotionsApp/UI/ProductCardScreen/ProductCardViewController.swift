import UIKit
import SnapKit
import Combine

class ProductCardViewController: UIViewController {

    private var product: Product?
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MainScreenCoordinator?

    private lazy var productScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = contentSize
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = contentSize
        return view
    }()

    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 900)
    }

    // Все кастомные вьюхи
    private let galleryView = ImageGalleryView()
    private let titleAndRatingView = UIView()
    private let titleView = ProductTitleView()
    private var ratingViewModel = RatingViewViewModel()
    private let ratingView = RatingView()
    private let offersTableView = UITableView()
    private let reviewViewViewModel = ProductReviewViewModel()
    private let reviewView = ProductReviewView()
    private let priceInfoViewModel = PriceInfoViewViewModel()
    private let priceInfoView = PriceInfoView()
    private let backButton = UIButton()
    private let exportButton = UIButton()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        if #available(iOS 11.0, *) {
            productScrollView.contentInsetAdjustmentBehavior = .never
        }

        setupProductLayout()
        configureViews()
        setupPriceInfoView()
        setupProductReviewView()
        setupRatingView()
        buttonsLayout()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func buttonsLayout() {
        view.addSubview(backButton)
        view.addSubview(exportButton)

        backButton.setImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(24)
        }

        exportButton.setImage(UIImage(named: "ic_export"), for: .normal)
        exportButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        exportButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(24)
        }
    }

    private func setupProductLayout() {
        view.addSubview(productScrollView)
        productScrollView.addSubview(contentView)
        [galleryView, titleView, ratingView, offersTableView, reviewView, priceInfoView].forEach {
            contentView.addSubview($0)
        }
        offersTableView.register(OfferTableViewCell.self, forCellReuseIdentifier: "OfferTableViewCell")
        offersTableView.dataSource = self
        offersTableView.delegate = self
        offersTableView.isScrollEnabled = false
        offersTableView.separatorStyle = .none
        // Ограничения SNAPkit
        productScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(productScrollView)
            make.bottom.greaterThanOrEqualTo(priceInfoView.snp.bottom).offset(16)
        }

        galleryView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(316)
            make.width.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.top.equalTo(galleryView.snp.bottom).offset(16)
            make.leading.equalTo(contentView)
            make.height.equalTo(43)
            make.width.equalTo(contentView.frame.width)
        }
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(36)
            make.width.equalTo(contentView.frame.width)
        }
        // Доп. настройка размеров таблицы
        let headerHeight: CGFloat = 19
        let topPadding: CGFloat = 12
        let cellHeight: CGFloat = 71
        let cellSpacing: CGFloat = 8
        let numberOfCells: CGFloat = CGFloat(product?.offers.count ?? 0)
        let tableViewHeight = headerHeight + topPadding + (cellHeight + cellSpacing) * numberOfCells - cellSpacing

        offersTableView.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(tableViewHeight)
            make.width.equalTo(contentView.frame.width)
        }
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(offersTableView.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        priceInfoView.snp.makeConstraints { make in
            make.top.equalTo(reviewView.snp.bottom).offset(8)
            make.leading.equalTo(contentView)
            make.height.equalTo(87)
            make.width.equalTo(contentView.frame.width)
        }
    }

    private func setupPriceInfoView() {
        priceInfoView.viewModel = priceInfoViewModel
        priceInfoViewModel.addToFavorites
            .sink { [weak self] in
                self?.addToFavorites()
            }
            .store(in: &cancellables)
    }

    private func setupProductReviewView() {
        reviewView.viewModel = reviewViewViewModel
        reviewViewViewModel.submitReview
            .sink { [weak self] rating, reviewText in
                        // Обработка отправки отзыва
                print("Отзыв с рейтингом \(rating): \(reviewText)")
            }
            .store(in: &cancellables)
    }

    private func setupRatingView() {
        ratingView.viewModel = ratingViewModel
        ratingViewModel.reviewsButtonTapped
            .sink { [weak self] in
                // Обработка нажатия на кнопку отзывов
                print("Отзывы показаны")
            }
            .store(in: &cancellables)
    }

    private func addToFavorites() {
        print("Нажатие кнопки В избранное")
    }

    private func configureViews() {
        var images: [UIImage] = []
        // Добавление основного изображения
        if let mainImageName = product?.image?.mainImage, let mainImage = UIImage(named: mainImageName) {
            images.append(mainImage)
        }
        // Добавление дополнительных изображений
        if let additionalPhotos = product?.image?.additionalPhoto {
            for photoName in additionalPhotos {
                if let image = UIImage(named: photoName) {
                    images.append(image)
                }
            }
        }

        // Если основное и дополнительные изображения отсутствуют, используем заглушку
        if images.isEmpty, let placeholderImage = UIImage(named: "placeholder") {
            images.append(placeholderImage)
            images.append(placeholderImage)
        }

        galleryView.configure(with: images)

        if let titleLabelText = product?.name, let weightLabelText = product?.description {
            titleView.configure(with: titleLabelText, weight: weightLabelText)
        } else {
            titleView.configure(with: "Title", weight: "Weight")
        }

        if let rating = product?.rating {
            ratingView.configure(with: rating, numberOfReviews: 0)
        } else {
            ratingView.configure(with: 1.0, numberOfReviews: 1)
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        print("Закрытие экрана")
    }

    @objc func sendButtonTapped() {
        print("Отправить другу")
    }
}

// MARK: - Клавиатура прыг-прыг
extension ProductCardViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height
        productScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardHeight,
            right: 0)
        productScrollView.scrollIndicatorInsets = productScrollView.contentInset

        // Проверяем, активен ли UITextView внутри ProductReviewView
        if reviewView.isFirstResponder {
            let rectInScrollView = productScrollView.convert(reviewView.frame, from: contentView)
            let offset = rectInScrollView.maxY - (view.bounds.height - keyboardHeight)
            let adjustedOffset = offset + 16
            if offset > 0 {
                productScrollView.setContentOffset(CGPoint(x: 0, y: adjustedOffset), animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        productScrollView.contentInset = UIEdgeInsets.zero
        productScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}

extension ProductCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product?.offers.count ?? 3 // TODO: Нужно сделать только чтобы максимум три магазина
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "OfferTableViewCell",
            for: indexPath) as? OfferTableViewCell,
              let store = product?.offers[indexPath.row] else {
            return UITableViewCell()
        }
        // Здесь конфигурируем ячейку с данными о магазине
        cell.selectionStyle = .none
        cell.configure(with: store)
        return cell
    }

}

extension ProductCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71 // высота каждой ячейки
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 19
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Предложения магазинов"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.textColor = .black

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)

        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        coordinator.goToStoreDetails(for: product?.stores[indexPath.row])
    }
}
