protocol ScanDelegateProtocol: AnyObject {
    func startScanFlow()
}

final class ScanFlowDelegate: ScanDelegateProtocol {
    var coordinator: ScanFlowCoordinatorProtocol?
    static let shared = ScanFlowDelegate()

    private init() { }

    func startScanFlow() {
        coordinator?.showScanner()
    }
}
