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

class CoordinatedViewController: UIViewController {
    weak var scanDelegate: ScanDelegateProtocol? = ScanDelegate.shared

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showScanner))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @objc
    private func showScanner() {
        print("scan")
        scanDelegate?.startScanFlow()
    }
}

protocol ScanDelegateProtocol: AnyObject {
    func startScanFlow()
}

final class ScanDelegate: ScanDelegateProtocol {
    var coordinator: ScanFlowCoordinatorProtocol?
    static let shared = ScanDelegate()

    private init() { }

    func startScanFlow() {
        coordinator?.showScanner()
    }
}
