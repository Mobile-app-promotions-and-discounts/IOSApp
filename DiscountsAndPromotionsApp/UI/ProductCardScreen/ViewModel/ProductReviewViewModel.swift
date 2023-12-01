//
//  ProductReviewViewModel.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 01.12.2023.
//

import UIKit
import Combine

class ProductReviewViewModel {
     let rating = CurrentValueSubject<Int, Never>(1)
     let reviewText = CurrentValueSubject<String, Never>("")
     let submitReview = PassthroughSubject<(Int, String), Never>()

     // Остальные методы и логика
 }
