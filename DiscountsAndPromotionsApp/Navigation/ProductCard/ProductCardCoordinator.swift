//
//  ProductCardCoordinator.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 21.11.2023.
//

import UIKit

final class ProductCardCoordinator: Coordinator {

    var childCoordinators =  [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}
    
    func showProductCard(for product: ProductModel) {
        let productVC = ProductCardViewController(product: product)
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
    
}
