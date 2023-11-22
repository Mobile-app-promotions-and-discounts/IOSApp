//
//  ScanFlowCoordinator.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 20.11.2023.
//

import UIKit

protocol ScanFlowCoordinatorProtocol: AnyObject {
    var navigation: UINavigationController {get set}
    func start()
    func goBack()
    func scanError()
}

final class ScanFlowCoordinator: ScanFlowCoordinatorProtocol {
    var navigation: UINavigationController
    
    let scanVC = ScanViewController()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        scanVC.hidesBottomBarWhenPushed = true
        scanVC.coordinator = self
        navigation.pushViewController(scanVC,
                                      animated: true)
    }
    
    func goBack() {
        navigation.popViewController(animated: true)
    }
    
    func scanError() {
        
    }
}
