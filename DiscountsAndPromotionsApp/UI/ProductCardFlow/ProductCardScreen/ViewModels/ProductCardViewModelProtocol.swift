import Foundation
import Combine

protocol ProductCardViewModelProtocol {
    var numberOfSections: Int { get }
    var sectionCellsPublisher: AnyPublisher<[[ProductCardCellType]], Never> { get }
    var reviewsCountHasChanged: PassthroughSubject<Void, Never> { get }

    func numberOfItems(inSection section: ProductCardSections) -> Int
    func cellTypes(forSection section: ProductCardSections) -> [ProductCardCellType]
    func getTitleFor(section: ProductCardSections) -> String
}
