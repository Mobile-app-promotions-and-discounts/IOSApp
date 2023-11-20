//
//  BarcodeModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import Foundation

enum Barcode: String {
    case ean8 = "EAN-8"
    case ean13 = "EAN-13"
    case upce = "UPC-E"
}

struct BarcodeModel {
    let type: Barcode
    let value: Int
}
