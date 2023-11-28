import UIKit

class ScannerEnabledViewController: UIViewController {
    weak var scanDelegate: ScanDelegateProtocol? = ScanFlowDelegate.shared

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showScanner))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", tableName: "MainFlow", comment: "")
        navigationItem.titleView = searchBar
    }

    @objc
    private func showScanner() {
        print("scan")
        scanDelegate?.startScanFlow()
    }
}
