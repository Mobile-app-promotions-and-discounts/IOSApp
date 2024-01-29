import UIKit

protocol ProductCardEnabledCoordinatorProtocol: Coordinator, AnyObject {
    func navigateToReviewsScreen(viewModel: ProductCardViewModel)
}

extension ProductCardEnabledCoordinatorProtocol {
    func navigateToReviewsScreen(viewModel: ProductCardViewModel) {
        let reviewsVC = ReviewsViewController(viewModel: viewModel)
        navigationController.pushViewController(reviewsVC, animated: true)
    }

    func openURL(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
