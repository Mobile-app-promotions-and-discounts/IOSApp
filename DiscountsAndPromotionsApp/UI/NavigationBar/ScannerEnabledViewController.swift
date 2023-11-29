import UIKit

class ScannerEnabledViewController: UIViewController {
    weak var scanDelegate: ScanDelegateProtocol? = ScanFlowDelegate.shared
    private var searchBar = UISearchBar()
    private var scanButton = UIButton(type: .infoDark)

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        scanButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        scanButton.tintColor = .mainAccent
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", tableName: "MainFlow", comment: "")
        searchBar.searchTextField.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.addSubview(scanButton)
        scanButton.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        scanButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -40).isActive = true
    }

    @objc
    private func showScanner() {
        print("scan")
        scanDelegate?.startScanFlow()
    }
}

extension ScannerEnabledViewController: UISearchBarDelegate {
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        showScanner()
    }
}

// сделать вид в котором кнопка положена на search bar или он прозрачный и рядом!! или addSybview
