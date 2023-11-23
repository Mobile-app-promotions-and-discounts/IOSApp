import UIKit

class ScanDummyViewController: UIViewController {
    var coordinator: ScanFlowCoordinatorProtocol?

    init(coordinator: ScanFlowCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showScanner))
    }

    @objc
    private func showScanner() {
        coordinator?.showScanner()
    }
}
