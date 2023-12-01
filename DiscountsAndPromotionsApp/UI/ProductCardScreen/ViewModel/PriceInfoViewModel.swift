//
//  PriceInfoViewModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 01.12.2023.
//

import UIKit
import Combine

class PriceInfoViewViewModel {
    @Published var price: Double = 0.0
    @Published var discountPrice = 0.0
    var addToFavorites = PassthroughSubject<Void, Never>()

}
