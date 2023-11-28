import UIKit

struct ProfileUIModel {
    let name: String
    let phone: String
    let avatarURL: String
    
    init(product: Product) {
        self.image = product.image?.mainImage
        self.name = product.name
        self.description = product.description
    }
}
