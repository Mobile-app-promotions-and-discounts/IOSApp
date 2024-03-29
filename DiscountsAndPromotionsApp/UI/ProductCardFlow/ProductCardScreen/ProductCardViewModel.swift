import UIKit
import Combine

private struct TableViewConstants {
    static let headerHeight: CGFloat = 19
    static let footerHeight: CGFloat = 12
    static let topPadding: CGFloat = 12
    static let cellHeight: CGFloat = 60
    static let cellSpacing: CGFloat = 8
}

final class ProductCardViewModel {
    @Published var product: Product?
    @Published var reviews: ProductReviews = []

    let addToFavoritesPublisher = PassthroughSubject<Void, Never>()
    let submitReviewPublisher = PassthroughSubject<(rating: Double, reviewText: String), Never>()
    let reviewsButtonTappedPublisher = PassthroughSubject<Void, Never>()

    private let ratingViewModel: RatingViewViewModelProtocol
    private let reviewViewViewModel: ProductReviewViewModelProtocol
    private let priceInfoViewModel: PriceInfoViewViewModelProtocol
    private let profileService: ProfileServiceProtocol
    private let productService: ProductNetworkServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(product: Product,
         productService: ProductNetworkServiceProtocol,
         mockProfileService: ProfileServiceProtocol) {
        self.product = product

        self.productService = productService
        self.profileService = mockProfileService
        self.ratingViewModel = RatingViewViewModel(rating: product.rating ?? 0.0)
        self.reviewViewViewModel = ProductReviewViewModel(productName: product.name)
        self.priceInfoViewModel = PriceInfoViewViewModel(profileService: profileService, product: product)

        setupBindings()
        productService.getReviewsForProduct(id: product.id, page: 1)
    }

    private func setupBindings() {
        productService.reviewListUpdate
            .sink { [weak self] reviewList in
                self?.reviews = reviewList
            }
            .store(in: &cancellables)

        productService.reviewCountUpdate
            .sink { [weak self] reviewCount in
                self?.ratingViewModel.setReviewCount(reviewCount)
            }
            .store(in: &cancellables)

        productService.didPostNewReviewUpdate
            .sink { [weak self] isReviewPosted in
                if let product = self?.product,
                   isReviewPosted {
                    self?.productService.getReviewsForProduct(id: product.id, page: 1)
                    self?.reviewViewViewModel.didPublishReview.send(isReviewPosted)
                }
            }
            .store(in: &cancellables)
    }

    func setupPriceInfoView(_ priceInfoView: PriceInfoView) {
        guard let product else { return }

        priceInfoView.viewModel = priceInfoViewModel
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

                guard let self,
                      let product = product else { return }

                // Обработка отправки отзыва
                let myReview = MyProductReview(text: reviewText, score: rating)
                self.productService.addNewReviewForProduct(id: product.id,
                                                            review: myReview)
            }
            .store(in: &cancellables)
    }

    func setupRatingView(_ ratingView: RatingView) {
        ratingView.viewModel = ratingViewModel

        ratingViewModel.reviewsButtonTapped
            .sink { [weak self] in
                // Обработка нажатия на кнопку отзывов
                if self?.ratingViewModel.reviewCountPublisher.value != 0 {
                    self?.reviewsButtonTappedPublisher.send()
                }
            }
            .store(in: &cancellables)
    }

    private func addToFavorites() {
        addToFavoritesPublisher.send()
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
