import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func navigateBack()
}

extension Coordinator {
    func navigateBack() {
        navigationController.popViewController(animated: true)
        navigationController.navigationBar.isHidden = true
    }

    func navigateToReviewsScreen(viewModel: ProductCardViewModel) {
        let reviewsVC = ReviewsViewController(viewModel: viewModel)
        navigationController.pushViewController(reviewsVC, animated: true)
    }
}
