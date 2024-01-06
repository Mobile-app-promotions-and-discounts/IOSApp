import UIKit
import SnapKit
import Combine

class ProductCardViewController: UIViewController {

    weak var coordinator: Coordinator?

    private var originalNavBarAppearance: UINavigationBarAppearance?

    private var viewModel: ProductCardViewModel!

    private var cancellables = Set<AnyCancellable>()

    private lazy var productScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = contentSize
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contentSize
        return view
    }()

    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 900)
    }

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
    private lazy var titleAndRatingView = UIView()
    private lazy var titleView = ProductTitleView()
    private lazy var ratingView = RatingView()
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
        setupBindings()
//        configureViews(with: viewModel.product)

        print("Product in ProductCardViewController: \(String(describing: viewModel.product))")

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

    private func configureViews(with product: Product?) {
        // Обновление UI на основе данных из ViewModel
        guard viewModel.product != nil else { return }
        viewModel.configureGalleryView(gallery)
        viewModel.configureTitleView(titleView)
        viewModel.configureRatingView(ratingView)
        viewModel.configureReviewView(reviewView)
        viewModel.configurePriceInfoView(priceInfoView)
    }

    // MARK: Mетоды для настройки UI
    private func setupProductLayout() {
        view.addSubview(productScrollView)
        productScrollView.addSubview(contentView)

        contentView.backgroundColor = .cherryLightBlue
        [galleryView, titleAndRatingView, offersTableView, reviewView, priceInfoView].forEach {
                contentView.addSubview($0)
        }

        titleAndRatingView.backgroundColor = .cherryWhite
        titleAndRatingView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        titleAndRatingView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
        [titleView, ratingView].forEach {
            titleAndRatingView.addSubview($0)
        }

        // Ограничения SNAPkit
        var statusBarHeight: CGFloat = 0
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        }
        productScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(productScrollView)
            make.bottom.equalToSuperview()
        }

        galleryView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(316)
            make.width.equalToSuperview()
        }

        titleAndRatingView.snp.makeConstraints { make in
            make.top.equalTo(galleryView.snp.bottom)
            make.leading.equalTo(contentView)
            make.height.equalTo(148)
            make.width.equalTo(contentView.frame.width)
        }

        titleView.snp.makeConstraints { make in
            make.top.equalTo(titleAndRatingView).offset(16)
            make.leading.equalTo(contentView)
            make.height.equalTo(50)
            make.width.equalTo(contentView.frame.width)
        }

        ratingView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(58)
            make.width.equalTo(contentView.frame.width)
        }

        offersTableView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        offersTableView.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(22)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(viewModel.calculateTableViewHeight())
            make.width.equalTo(contentView.frame.width)
        }

        reviewView.backgroundColor = .cherryWhite
        reviewView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(offersTableView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        priceInfoView.backgroundColor = .cherryWhite
        priceInfoView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        priceInfoView.snp.makeConstraints { make in
            make.top.equalTo(reviewView.snp.bottom).offset(16)
            make.leading.equalTo(contentView)
            make.bottom.equalToSuperview()
            make.width.equalTo(contentView.frame.width)
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
