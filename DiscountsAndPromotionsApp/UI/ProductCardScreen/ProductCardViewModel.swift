//
//  ProductCardViewModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 15.12.2023.
//

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
    private var reviewViewViewModel: ProductReviewViewModelProtocol
    private var priceInfoViewModel: PriceInfoViewViewModelProtocol?

    private var cancellables = Set<AnyCancellable>()

    init(product: Product) {
        self.product = product

        self.ratingViewModel = RatingViewViewModel(rating: product.rating ?? 1.0, numberOfReviews: 0)
        self.reviewViewViewModel = ProductReviewViewModel(productName: product.name)
        self.priceInfoViewModel = PriceInfoViewViewModel(profileService: MockProfileService(), product: product)

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

        let priceInfoViewModel = PriceInfoViewViewModel(profileService: MockProfileService(), product: product)

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

    func configureGalleryView(_ galleryView: ImageGalleryView) {
        var images: [UIImage] = []
        // Добавление основного изображения
        if let mainImageName = product?.image?.mainImage, let mainImage = UIImage(named: mainImageName) {
            images.append(mainImage)
        }
        // Добавление доп изображений
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
    }

    func configureTitleView(_ titleView: ProductTitleView) {
        if let titleLabelText = product?.name, let weightLabelText = product?.description {
            titleView.configure(with: titleLabelText, weight: weightLabelText)
        } else {
            titleView.configure(with: "Title", weight: "Weight")
        }
    }

    func configureRatingView(_ ratingView: RatingView) {
        if let rating = product?.rating {
            ratingView.configure(with: rating, numberOfReviews: 0)
        } else {
            ratingView.configure(with: 1.0, numberOfReviews: 1)
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
            print("Configuring PriceInfoView with price: \(minPrice)")
            priceInfoView.configure(with: 180, discountPrice: Int(minPrice))
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