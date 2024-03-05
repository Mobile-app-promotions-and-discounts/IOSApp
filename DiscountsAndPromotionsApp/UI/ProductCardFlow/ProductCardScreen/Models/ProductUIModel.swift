import UIKit

struct ProductUIModel {
    let image: String?

    init(product: Product) {
        self.image = product.image?.mainImage
    }
}
