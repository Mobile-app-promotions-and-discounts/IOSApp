//
//  ProductCardViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import UIKit

class ProductCardViewController: UIViewController {
    
    enum Section {
        case gallery
        case title
        case rating
        case stores
        case review
        case priceInfo
    }
    
    var product: ProductModel?
    weak var coordinator: ProductCardCoordinator?
    
    private var collectionView: UICollectionView!
    
    init(product: ProductModel) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Регистрация кастомных ячеек
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: "ImageGalleryCell")
        collectionView.register(ProductTitleCell.self, forCellWithReuseIdentifier: "ProductTitleCell")
        collectionView.register(RatingCell.self, forCellWithReuseIdentifier: "RatingCell")
        collectionView.register(StoreCell.self, forCellWithReuseIdentifier: "StoreCell")
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: "ReviewCell")
        collectionView.register(PriceInfoCell.self, forCellWithReuseIdentifier: "PriceInfoCell")
        
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Создание композиционного макета для разных секций
        // ...
    }
    

}

extension ProductCardViewController: UICollectionViewDelegate {
    
}

extension ProductCardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}
