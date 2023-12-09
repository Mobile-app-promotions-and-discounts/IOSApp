import UIKit

struct CategoryUIModel {
    let title: String
    let image: UIImage

    init(category: Category) {
        self.title = category.name
        self.image = UIImage(named: category.image) ?? UIImage()
    }
}
