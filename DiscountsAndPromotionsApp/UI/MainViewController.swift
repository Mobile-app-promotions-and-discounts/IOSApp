import UIKit

final class MainViewController: UIViewController {
    weak var coordinator: MainScreenCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
