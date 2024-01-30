//
//  RecoveryStartViewModelProtocol.swift
//  DiscountsAndPromotionsApp
//
//  Created by Александр Кудряшов on 30.01.2024.
//

import Combine
import Foundation

protocol RecoveryStartViewModelProtocol {
    var dataTextFields: [DataTextField] { get }
    var timeLeft: CurrentValueSubject<Int, Never> { get }
    var isTimerEnded: PassthroughSubject<Bool, Never> { get }
    var code: AnyPublisher<String, Never> { get }
    var isCodeDone: AnyPublisher<Bool, Never> { get }
    func sendCode()
    func changeTextField(id: Int, text: String)
}
