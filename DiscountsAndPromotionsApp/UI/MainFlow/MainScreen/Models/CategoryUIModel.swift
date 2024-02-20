import UIKit

struct CategoryUIModel {
    let title: String
    let image: String?

    init(category: Category) {
        self.title = category.name
        self.image = category.image
    }
}
