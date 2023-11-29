import UIKit

class ScannerEnabledViewController: SearchEnabledViewController {
    weak var scanDelegate: ScanDelegateProtocol? = ScanFlowDelegate.shared
    private var scanButton = UIButton(type: .infoDark)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanButton()
    }

    private func setupScanButton() {
        searchBar.addSubview(scanButton)
        scanButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        scanButton.tintColor = .cherryMainAccent
        scanButton.setImage(UIImage(systemName: "barcode.viewfinder"), for: .normal)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        scanButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -40).isActive = true
    }

    @objc
    private func showScanner() {
        scanDelegate?.startScanFlow()
    }
}
