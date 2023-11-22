//
//  ScanViewModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 21.11.2023.
//

import Combine
import Foundation

final class ScanFlowViewModel {
    @Published var isManualInputActive: Bool = false
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
    }
}
