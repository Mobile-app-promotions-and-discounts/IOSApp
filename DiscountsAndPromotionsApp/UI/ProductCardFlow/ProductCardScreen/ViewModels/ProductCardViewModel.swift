import Foundation
import Combine

final class ProductCardViewModel: ProductCardViewModelProtocol {
    var numberOfSections: Int {
        return ProductCardSections.allCases.count
    }

    var sectionCellsPublisher: AnyPublisher<[[ProductCardCellType]], Never> {
        sectionCells.eraseToAnyPublisher()
    }

    var reviewsCountHasChanged = PassthroughSubject<Void, Never>()

    private let productService: ProductNetworkServiceProtocol
    private let product: Product

    private var sectionCells = CurrentValueSubject<[[ProductCardCellType]], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    private var sectionCellsValue = [[ProductCardCellType]]() {
        didSet {
            sectionCells.send(sectionCellsValue)
        }
    }

    private var reviewsCountValue: Int = 0 {
        didSet {
            reviewsCountHasChanged.send()
        }
    }

    init(product: Product, productService: ProductNetworkServiceProtocol) {
        self.productService = productService
        self.product = product
        setupBindings()
        productService.getReviewsForProduct(id: product.id, page: 1)
    }

    func numberOfItems(inSection section: ProductCardSections) -> Int {
        switch section {
        case .imagesAndReviews:
            return 3
        case .storeOffers:
            return 2 // Заменить на тайтл + офферы
        }
    }

    func cellTypes(forSection section: ProductCardSections) -> [ProductCardCellType] {
        switch section {
        case .imagesAndReviews:
            return [.image(getImage()), .name(getName()), .reviewsInfo(getReviewsInfo())]
        case .storeOffers:
            return [.storeOffers, .storeOffers]
        }
    }

    func getTitleFor(section: ProductCardSections) -> String {
        switch section {
        case .imagesAndReviews:
            return ""
        case .storeOffers:
            return NSLocalizedString("Shop's Offers", tableName: "ProductFlow", comment: "")
        }
    }

    private func setupBindings() {
        productService.reviewCountUpdate
            .sink { [weak self] reviewCount in
                self?.reviewsCountValue = reviewCount

            }
            .store(in: &cancellables)
    }

    private func getImage() -> ProductImageUIModel {
        return ProductImageUIModel(product: product)
    }

    private func getName() -> ProductTitleUIModel {
        return ProductTitleUIModel(name: product.name)
    }

    private func getReviewsInfo() -> ProductReviewsInfoUIModel {
        return ProductReviewsInfoUIModel(product: product, reviewsCount: self.reviewsCountValue)
    }
}
