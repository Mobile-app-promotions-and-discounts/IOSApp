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

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        // Пример связывания с UITextView

        reviewText
            .sink { text in
                print(text)
            }
            .store(in: &cancellables)
    }
     // Остальные методы и логика
 }
