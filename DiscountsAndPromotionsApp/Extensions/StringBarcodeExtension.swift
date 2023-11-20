//
//  BarcodeModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import Foundation

extension String {
    func isValidBarcode() -> Bool {
        let pattern = "^[0-9]{8}$|^[0-9]{13}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
