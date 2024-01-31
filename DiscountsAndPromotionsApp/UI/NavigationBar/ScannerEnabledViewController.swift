import UIKit

class ScannerEnabledViewController: SearchEnabledViewController {
    private var scanButton = UIButton(type: .infoDark)

    func hideScanButton() {
        scanButton.isHidden = true
    }

    func showScanButton() {
        scanButton.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanButton()
    }

    private func setupScanButton() {
        searchBar.addSubview(scanButton)
        scanButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        scanButton.tintColor = .cherryMainAccent
        scanButton.setImage(UIImage.scannerIcon, for: .normal)
        scanButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalTo(searchBar.snp.trailing).offset(-28)
        }
        showScanButton()
    }

    @objc
    private func showScanner() {
        if let navController = navigationController as? GenericNavigationController,
        let scanCoordinator = navController.scanCoordinator {
            scanCoordinator.showScanner()
        }
    }
}
