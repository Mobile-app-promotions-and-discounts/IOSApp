import UIKit
import Combine

private struct TableViewConstants {
    static let headerHeight: CGFloat = 19
    static let footerHeight: CGFloat = 12
    static let topPadding: CGFloat = 12
    static let cellHeight: CGFloat = 60
    static let cellSpacing: CGFloat = 8
}

class ProductCardViewModel {
    @Published var product: Product?
    let addToFavoritesPublisher = PassthroughSubject<Void, Never>()
    let submitReviewPublisher = PassthroughSubject<(rating: Double, reviewText: String), Never>()
    let reviewsButtonTappedPublisher = PassthroughSubject<Void, Never>()

    private let ratingViewModel: RatingViewViewModelProtocol
    private let reviewViewViewModel: ProductReviewViewModelProtocol
    private let priceInfoViewModel: PriceInfoViewViewModelProtocol
    private let profileService: ProfileServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(product: Product, mockProfileService: ProfileServiceProtocol) {
        self.product = product

        self.profileService = mockProfileService
        self.ratingViewModel = RatingViewViewModel(rating: product.rating ?? 1.0, numberOfReviews: 0)
        self.reviewViewViewModel = ProductReviewViewModel(productName: product.name)
        self.priceInfoViewModel = PriceInfoViewViewModel(profileService: profileService, product: product)

        setupBindings()
    }

    private func setupBindings() {
        // Установка связей между данными и логикой обработки.
        // Например, обработка изменений в product или взаимодействие с сервисами
    }

    func setupPriceInfoView(_ priceInfoView: PriceInfoView) {
        guard let product = product else {
            print("Product is nil in setupPriceInfoView")
            return }

        priceInfoView.viewModel = priceInfoViewModel
        print("ViewModel is set in PriceInfoView")

        priceInfoViewModel.addToFavorites
            .sink { [weak self] in
                self?.addToFavoritesPublisher.send()
            }
            .store(in: &cancellables)
    }

    func setupProductReviewView(_ reviewView: ProductReviewView) {
        reviewView.viewModel = reviewViewViewModel
        reviewView.configure(with: product?.name ?? "")

        reviewViewViewModel.submitReview
            .sink { [weak self] rating, reviewText in
                // Обработка отправки отзыва
                print("Отзыв с рейтингом \(rating): \(reviewText)")
            }
            .store(in: &cancellables)
    }

    func setupRatingView(_ ratingView: RatingView) {
        ratingView.viewModel = ratingViewModel

        ratingViewModel.reviewsButtonTapped
            .sink { [weak self] in
                // Обработка нажатия на кнопку отзывов
                print("Отзывы показаны")
            }
            .store(in: &cancellables)
    }

    private func addToFavorites() {
        addToFavoritesPublisher.send()
        print("Нажатие кнопки В избранное")
    }

    // MARK: Конфиг UI Элементов

    func configureGalleryView(_ galleryView: ImageGalleryController) {
        var images = [String]()
        if let mainImage = product?.image?.mainImage {
            images.append(mainImage)
        }
        if let additionalImages = product?.image?.additionalPhoto {
            for image in additionalImages {
                images.append(image)
            }
        }
        galleryView.setURLs(urls: images)
    }

    func configureTitle(_ titleLabel: UILabel) {
        titleLabel.text = product?.name ?? "..."
    }

    func configureRatingView(_ ratingView: RatingView) {
        if let rating = product?.rating {
            ratingView.configure(with: rating, numberOfReviews: 0)
        } else {
            ratingView.configure(with: 0.0, numberOfReviews: 0)
        }
    }

    func configureReviewView(_ reviewView: ProductReviewView) {
        if let productName = product?.name {
            reviewView.configure(with: productName)
        }
    }

    func configurePriceInfoView(_ priceInfoView: PriceInfoView) {
        if let product = product {
            let minPrice = product.findMinMaxOffers().minOffer?.price ?? 0
            let maxOriginalPrice = product.findMinMaxInitialOffers().maxOffer?.initialPrice ?? 0
            print("Configuring PriceInfoView with price: \(minPrice)")
            priceInfoView.configure(with: Int(maxOriginalPrice), discountPrice: Int(minPrice))
        }
    }

    // Методы для UITableViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        return product?.offers.count ?? 0
    }

    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as? OfferTableViewCell,
              let offer = product?.offers[indexPath.row] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: offer)
        return cell
    }

    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // Другие методы

    func calculateTableViewHeight() -> CGFloat {
        let numberOfCells = CGFloat(product?.offers.count ?? 0)
        return TableViewConstants.headerHeight +
        TableViewConstants.topPadding +
        TableViewConstants.footerHeight +
        (TableViewConstants.cellHeight + TableViewConstants.cellSpacing) * numberOfCells -
        TableViewConstants.cellSpacing
    }
}
