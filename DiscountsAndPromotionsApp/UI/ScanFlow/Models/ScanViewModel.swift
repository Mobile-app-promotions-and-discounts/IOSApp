import Combine
import Foundation
// временное решение для показа штрих-кода
import UIKit

protocol ScanFlowViewModelProtocol {
    var manualInputUpdate: PassthroughSubject<Bool, Never> { get }
    var validBarcodeUpdate: PassthroughSubject<Bool, Never> { get }

    func bindBarcode(code: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never>
    func bindSegmentedControl(index: AnyPublisher<Int, Never>)
    func checkBarcode()
    func checkBarcode(code: String)
}

final class ScanFlowViewModel: ScanFlowViewModelProtocol {
    private (set) var manualInputUpdate = PassthroughSubject<Bool, Never>()
    private (set) var validBarcodeUpdate = PassthroughSubject<Bool, Never>()
    @Published private var isManualInputActive: Bool = false {
        didSet {
            manualInputUpdate.send(isManualInputActive)
        }
    }
    @Published private var isValidBarcode: Bool = false {
        didSet {
            validBarcodeUpdate.send(isValidBarcode)
        }
    }
    private var currentBarcode: String = ""

    private var subscriptions: Set<AnyCancellable> = Set()

    func bindBarcode(code: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        code.sink { [weak self] barcode in
            self?.isValidBarcode = barcode.isValidBarcode()
            self?.currentBarcode = barcode
        }.store(in: &subscriptions)

        return Publishers.CombineLatest($isValidBarcode, $isManualInputActive)
            .map { isValid, isManual in
                if isManual {
                    return isValid
                } else {
                    return true
                }
            }.eraseToAnyPublisher()
    }

    func bindSegmentedControl(index: AnyPublisher<Int, Never>) {
        index.sink { [weak self] index in
            self?.isManualInputActive = (index == 1) ? true : false
        }.store(in: &subscriptions)

    }

    func checkBarcode() {
        if isValidBarcode {
            makeBarcodeRequest(code: currentBarcode)
        }
    }

    func checkBarcode(code: String) {
        makeBarcodeRequest(code: code)
    }

    private func makeBarcodeRequest(code: String) {
        // TODO: связать с сетевым слоем
        print("Barcode for \(code)")
        // временное наглядное решение
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let navigationController = window.rootViewController as? UINavigationController {
            let topController = navigationController.viewControllers.last
            let alert = UIAlertController(title: "Код отсканирован",
                                          message: "\(code)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            topController?.present(alert, animated: true)
        }
    }
}
