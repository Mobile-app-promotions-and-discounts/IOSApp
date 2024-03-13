import UIKit

protocol ProductCardEnabledCoordinatorProtocol: Coordinator, AnyObject {
    func navigateToReviewsScreen(viewModel: ProductCardViewModelProtocol)
}

extension ProductCardEnabledCoordinatorProtocol {
    func navigateToReviewsScreen(viewModel: ProductCardViewModelProtocol) {
        let reviewsVC = ReviewsViewController(viewModel: viewModel)
        reviewsVC.coordinator = self
        navigationController.pushViewController(reviewsVC, animated: true)
    }

    func showModalReviewController(viewModel: ProductCardViewModelProtocol) {
        let modalVC = ModalReviewViewController(viewModel: viewModel)
        modalVC.coordinator = self
        modalVC.modalPresentationStyle = .pageSheet
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.present(modalVC, animated: true)
    }

    func openURL(urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
