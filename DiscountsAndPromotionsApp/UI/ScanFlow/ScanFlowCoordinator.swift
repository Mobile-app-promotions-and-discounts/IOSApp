//
//  ScanFlowCoordinator.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import UIKit

final class ScanFlowCoordinator {
    var navigation: UINavigationController
    
    var scanVC = ScanViewController()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        scanVC.hidesBottomBarWhenPushed = true
        navigation.pushViewController(scanVC,
                                      animated: true)
    }
}
