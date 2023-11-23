import Combine
import Foundation
// временное решение для показа штрих-кода
import UIKit

final class ScanFlowViewModel {
    @Published private(set) var isManualInputActive: Bool = false
    @Published var isValidBarcode: Bool = false
    private var currentBarcode: String = ""

    private var barcodeSubscription: AnyCancellable?

    func bindBarcode(code: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        barcodeSubscription = code.sink { [weak self] barcode in
            self?.isValidBarcode = barcode.isValidBarcode()
            self?.currentBarcode = barcode
        }

        return Publishers.CombineLatest($isValidBarcode, $isManualInputActive)
            .map { isValid, isManual in
                if isManual {
                    return isValid
                } else {
                    return true
                }
            }.eraseToAnyPublisher()
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

    func setManualInputActive(to input: Bool) {
        isManualInputActive = input
    }
}
