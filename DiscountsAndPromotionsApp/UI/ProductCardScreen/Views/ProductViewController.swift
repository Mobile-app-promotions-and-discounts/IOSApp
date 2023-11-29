//
//  ProductViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//
import UIKit

class ProductCardViewController: UIViewController {

    var product: Product?
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
    private let titleView = ProductTitleView()
    private let ratingView = RatingView()
    private let offersTableView = UITableView()
    private let reviewView = ProductReviewView()
    private let priceInfoView = PriceInfoView()

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

        setupNavigationbar()
        setupProductLayout()
        configureViews()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification: )),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification: )),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setupNavigationbar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)

        let uploadButton = UIButton(type: .system)
        uploadButton.setImage(UIImage(named: "sendImage"), for: .normal)
        uploadButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        let uploadButtonItem = UIBarButtonItem(customView: uploadButton)

        [backButton, uploadButton].forEach {
            $0.backgroundColor = .mainBG
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.tintColor = .black
        }

        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = uploadButtonItem
    }

    private func setupProductLayout() {
        view.addSubview(productScrollView)
        productScrollView.addSubview(contentView)

        contentView.addSubview(galleryView)
        galleryView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(ratingView)
        ratingView.delegate = self
        ratingView.translatesAutoresizingMaskIntoConstraints = false

        // Таблица Магазинов
        contentView.addSubview(offersTableView)
        offersTableView.translatesAutoresizingMaskIntoConstraints = false
        offersTableView.register(OfferTableViewCell.self, forCellReuseIdentifier: "OfferTableViewCell")
        offersTableView.dataSource = self
        offersTableView.delegate = self
        offersTableView.isScrollEnabled = false
        offersTableView.separatorStyle = .none

        //
        contentView.addSubview(reviewView)
        ratingView.delegate = self
        reviewView.translatesAutoresizingMaskIntoConstraints = false

        //
        contentView.addSubview(priceInfoView)
        priceInfoView.delegate = self
        priceInfoView.translatesAutoresizingMaskIntoConstraints = false

        // Ограничения для ScrollView и ContentView
        NSLayoutConstraint.activate([
            productScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            productScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: productScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: productScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: productScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: productScrollView.bottomAnchor)
        ])

        // Ограничения для GalleryView
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            galleryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            galleryView.heightAnchor.constraint(equalToConstant: 316),
            galleryView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
            // Высота должна быть задана
        ])

        // Ограничения для TitleView
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: galleryView.bottomAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 43),
            titleView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
        ])

        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 36),
            ratingView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
        ])

        // Работа с размером таблицы
        let headerHeight: CGFloat = 19
        let topPadding: CGFloat = 12
        let cellHeight: CGFloat = 71
        let cellSpacing: CGFloat = 8
        let numberOfCells: CGFloat = CGFloat(product?.offers.count ?? 0)
        let tableViewHeight = headerHeight + topPadding + (cellHeight + cellSpacing) * numberOfCells - cellSpacing

        // Ограничения для StoresTableView
        NSLayoutConstraint.activate([
            offersTableView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16),
            offersTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            offersTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            offersTableView.heightAnchor.constraint(equalToConstant: tableViewHeight),
            offersTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])

        // Ограничения для ReviewView
        NSLayoutConstraint.activate([
            reviewView.topAnchor.constraint(equalTo: offersTableView.bottomAnchor, constant: 16),
            reviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Ограничения для PriceInfoView
        NSLayoutConstraint.activate([
            priceInfoView.topAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: 8),
            priceInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceInfoView.heightAnchor.constraint(equalToConstant: 87),
            priceInfoView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: priceInfoView.bottomAnchor, constant: 16)
        ])
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

        //        if let imageName = product?.image?.mainImage + product?.image?.additionalPhoto,
        //            let images = UIImage(named: imageName) {
        //            galleryView.configure(with: image)
        //        } else {
        //            galleryView.configure(with: [UIImage(named: "placeholder")])
        //        }

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

extension ProductCardViewController: RatingViewDelegate {
    func reviewsButtonTapped() {
        // сюда координатора бахнуть
        print("Нажатие кнопки перехода к комментариям")
    }
}

extension ProductCardViewController: PriceInfoViewDelegate {
    func addToFavorites() {
        dismiss(animated: true)
        print("Нажатие кнопки В избранное")
    }
}

// MARK: - Клавиатура прыг-прыг
extension ProductCardViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height
        productScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
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
//            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)

        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        coordinator.goToStoreDetails(for: product?.stores[indexPath.row])
    }
}
