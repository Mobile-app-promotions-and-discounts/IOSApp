import UIKit
import Combine
import SnapKit

final class FavoritesViewController: ProductListViewController {
    override init(viewModel: ProductListViewModelProtocol,
                  layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        super.init(viewModel: viewModel, layoutProvider: layoutProvider)
        setEmptyResultsMode(to: .noFavorites)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
