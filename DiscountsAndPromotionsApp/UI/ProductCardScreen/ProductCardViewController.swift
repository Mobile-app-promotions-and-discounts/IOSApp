import UIKit
import SnapKit
import Combine

class ProductCardViewController: UIViewController {
    weak var coordinator: Coordinator?

    private var originalNavBarAppearance: UINavigationBarAppearance?

    private var viewModel: ProductCardViewModel

    private var cancellables = Set<AnyCancellable>()

    private lazy var productScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private lazy var scrollContentContainer = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        return container
    }()

    // Все кастомные вьюхи
    private lazy var gallery = ImageGalleryController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
    private lazy var galleryView: UIView = {
        let gallery = gallery.view ?? UIView()

        let galleryBackground = UIView()
        galleryBackground.backgroundColor = .cherryWhite
        galleryBackground.addSubview(gallery)

        gallery.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
        return galleryBackground
    }()
    private lazy var titleAndRatingView = {
        let view = UIView()
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    private lazy var ratingView = RatingView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerLarge
        label.textColor = .cherryBlack
        label.numberOfLines = 0
        return label
    }()
    private lazy var offersTableView = UITableView()
    private lazy var reviewView = ProductReviewView()
    private lazy var priceInfoView = PriceInfoView()
    private lazy var backButton = UIButton()
    private lazy var exportButton = UIButton()

    init(viewModel: ProductCardViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - LifeCycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalNavBarAppearance = navigationController?.navigationBar.standardAppearance.copy()
        setupProductNavigationBar()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cherryWhite

        productScrollView.delegate = self
        productScrollView.contentInsetAdjustmentBehavior = .never
        setupUI()
        setupViewConfiguration()
        setupBindings()

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
           // первоначальный вид navbar
           if let originalAppearance = originalNavBarAppearance {
               navigationController?.navigationBar.standardAppearance = originalAppearance
               navigationController?.navigationBar.scrollEdgeAppearance = originalAppearance
               navigationController?.navigationBar.compactAppearance = originalAppearance
               navigationController?.navigationBar.compactScrollEdgeAppearance = originalAppearance
           }

        navigationController?.setNavigationBarHidden(false, animated: false)
       }

    // MARK: - Private Func
    private func setupUI() {
        // Настройка UI-элементов
        setupProductLayout()
        setupTableView()
    }

    private func setupBindings() {
        viewModel.$product
            .receive(on: RunLoop.main)
            .sink { [weak self] product in
                self?.configureViews(with: product)
            }
            .store(in: &cancellables)
    }

    private func setupViewConfiguration() {
        viewModel.setupPriceInfoView(priceInfoView)
    }

    private func configureViews(with product: Product?) {
        // Обновление UI на основе данных из ViewModel
        guard viewModel.product != nil else { return }
        viewModel.configureGalleryView(gallery)
        viewModel.configureTitle(titleLabel)
        viewModel.configureRatingView(ratingView)
        viewModel.configureReviewView(reviewView)
        viewModel.configurePriceInfoView(priceInfoView)
    }

    // MARK: Mетоды для настройки UI
    private func setupProductLayout() {
        [productScrollView, priceInfoView].forEach {
            view.addSubview($0)
        }
        productScrollView.addSubview(scrollContentContainer)

        [galleryView, titleAndRatingView, offersTableView, reviewView].forEach {
            scrollContentContainer.addArrangedSubview($0)
        }

        titleAndRatingView.backgroundColor = .cherryWhite
        titleAndRatingView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        titleAndRatingView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        [titleLabel, ratingView].forEach {
            titleAndRatingView.addSubview($0)
        }

        // Ограничения SNAPkit
        var statusBarHeight: CGFloat = 0
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.cherryLightBlue.cgColor, UIColor.cherryWhite.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight * 2)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundColor = .cherryLightBlue

        priceInfoView.backgroundColor = .cherryWhite
        priceInfoView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        priceInfoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        priceInfoView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }

        productScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight)
            make.leading.bottom.trailing.equalToSuperview()
        }
        productScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 96, right: 0)
        productScrollView.backgroundColor = .clear

        scrollContentContainer.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(productScrollView.contentLayoutGuide)
        }

        galleryView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(316)
            make.width.equalTo(view)
        }

        titleAndRatingView.snp.makeConstraints { make in
            make.top.equalTo(galleryView.snp.bottom)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleAndRatingView).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        ratingView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }

        offersTableView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        offersTableView.snp.makeConstraints { make in
            make.top.equalTo(titleAndRatingView.snp.bottom).offset(16)
            make.height.equalTo(viewModel.calculateTableViewHeight())
        }

        reviewView.backgroundColor = .cherryWhite
        reviewView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(offersTableView.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-164)
        }
    }

    private func setupTableView() {
        offersTableView.register(OfferTableViewCell.self, forCellReuseIdentifier: "OfferTableViewCell")
        offersTableView.dataSource = self
        offersTableView.delegate = self
        offersTableView.isScrollEnabled = false
        offersTableView.separatorStyle = .none
        offersTableView.backgroundColor = .cherryWhite
    }

    // MARK: - Navigation bar appearence
    private func setupProductNavigationBar() {
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.titleTextAttributes = [ .foregroundColor: UIColor.clear ]

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.cherryWhite

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: CherryFonts.headerMedium as Any
        ]
        standardAppearance.titleTextAttributes = titleAttributes

        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationController?.navigationBar.compactAppearance = standardAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = scrollEdgeAppearance

        [backButton, exportButton].forEach {
            $0.tintColor = .cherryGray
            $0.backgroundColor = .cherryWhite.withAlphaComponent(0.8)
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(32)
            }
            $0.layer.cornerRadius = 16
        }
        backButton.setImage(UIImage.back, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        exportButton.setImage(UIImage.icExport, for: .normal)
        exportButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exportButton)

        navigationItem.title = viewModel.product?.name
    }

    @objc func backButtonTapped() {
        coordinator?.navigateBack()
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
            let rectInScrollView = productScrollView.convert(reviewView.frame, from: scrollContentContainer)
            let offset = rectInScrollView.maxY - (view.bounds.height - keyboardHeight)
            let adjustedOffset = offset + 30
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
        viewModel.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRowAt(tableView, indexPath: indexPath)
        // Здесь конфигурируем ячейку с данными о магазине
    }
}

extension ProductCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath)
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
        headerLabel.font = CherryFonts.headerLarge
        headerLabel.textColor = .black

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)

        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        footerView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        coordinator.goToStoreDetails(for: product?.stores[indexPath.row])
    }
}
