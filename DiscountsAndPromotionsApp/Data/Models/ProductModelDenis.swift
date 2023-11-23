//
//  ProductModelDenis.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import Foundation

// Основная модель продукта
struct ProductModel: Codable {
    let id: Int
    let name: String
    let category: Category
    let description: String?
    let image: String? // URL в виде строки
    let rating: Int // Предполагаю, что рейтинг от 0 до 100
    let store: [StoreInfo]
    
    struct Category: Codable {
        let id: Int
        let name: String
    }
    
    struct StoreInfo: Codable {
        let id: Int
        let price: Double
        let discount: Discount?
        let stores: Store
        
        struct Discount: Codable {
            let id: Int
            let discountRate: Int
            let discountCard: Bool
            
            enum CodingKeys: String, CodingKey {
                case id
                case discountRate = "discount_rate"
                case discountCard = "discount_card"
            }
        }
        
        struct Store: Codable {
            let id: Int
            let location: Location
            let chainStore: ChainStore
            
            struct Location: Codable {
                let id: Int
                let region: String
                let city: String
                let street: String
                let building: Int
                let postalIndex: Int
                
                enum CodingKeys: String, CodingKey {
                    case id, region, city, street, building
                    case postalIndex = "postal_index"
                }
            }
            
            struct ChainStore: Codable {
                let id: Int
                let name: String
            }
            
            let name: String
        }
    }
}
