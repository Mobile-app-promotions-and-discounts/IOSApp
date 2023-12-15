//
//  ProductCardViewModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 15.12.2023.
//

import UIKit
import Combine

class ProductCardViewModel {
    
    @Published var product: Product?
    private var cancellables = Set<AnyCancellable>()
    
    init(product: Product) {
        self.product = product
    }
    
    
    
}
