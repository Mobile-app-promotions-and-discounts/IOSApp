//
//  UITextView + Extension.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 01.12.2023.
//

import UIKit
import Combine

extension UITextView {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text }
            .eraseToAnyPublisher()
    }

    var beginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: self)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }

    var endEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: self)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }

}
