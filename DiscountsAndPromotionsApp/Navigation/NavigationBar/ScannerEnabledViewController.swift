import UIKit

class ScannerEnabledViewController: SearchEnabledViewController {
    weak var scanCoordinator: ScanFlowCoordinator?
    private var scanButton = UIButton(type: .infoDark)

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
    }

    @objc
    private func showScanner() {
        scanCoordinator?.showScanner()
    }
}
