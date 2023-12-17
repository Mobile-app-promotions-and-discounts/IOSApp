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
    private let dataService: DataServiceProtocol
    private let coordinator: ScanFlowCoordinator

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

    init(dataService: DataServiceProtocol,
         coordinator: ScanFlowCoordinator) {
        self.dataService = dataService
        self.coordinator = coordinator
    }

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
        dataService.actualGoodsList
            .sink { [weak self] goodsList in
                guard let self = self else { return }
                let sortedGoodsList = goodsList.filter { product in
                    return product.barcode == code
                }
                if let product = sortedGoodsList.first {
                    coordinator.showProduct(product)
                } else {
                    coordinator.scanError()
                }
            }
            .store(in: &subscriptions)
    }
}
