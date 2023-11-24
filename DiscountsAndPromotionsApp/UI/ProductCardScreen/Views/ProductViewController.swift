//
//  ProductViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//
import UIKit

class ProductCardViewController: UIViewController {

    var product: Product?
    weak var coordinator: MainScreenCoordinator?

//    private lazy var productScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.alwaysBounceVertical = true
//        scrollView.showsVerticalScrollIndicator = true
////        scrollView.contentSize = contentSize
//        return scrollView
//    }()

//    private lazy var contentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
////        view.frame.size = contentSize
//        return view
//    }()

    //    private var contentSize: CGSize {
    //        CGSize(width: view.frame.width, height: view.frame.height + 200)
    //    }

    private let galleryView = ImageGalleryView()
    private let titleView = ProductTitleView()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupProductLayout()
        configureViews()
    }

    private func setupProductLayout() {
//        view.addSubview(productScrollView)

        // Добавление GalleryView и TitleView непосредственно на UIScrollView
        view.addSubview(galleryView)
        view.addSubview(titleView)

        // Ограничения для ScrollView
//        NSLayoutConstraint.activate([
//            productScrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            productScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            productScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            productScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])

        // Ограничения для GalleryView
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            galleryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryView.heightAnchor.constraint(equalToConstant: 288) // Высота должна быть задана
        ])

        // Ограничения для TitleView
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: galleryView.bottomAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            titleView.trailingAnchor.constraint(equalTo: productScrollView.frameLayoutGuide.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 100) // Примерная высота, если не определена внутри TitleView
        ])

        // Ограничения для bottomAnchor последнего элемента
//        NSLayoutConstraint.activate([
//            titleView.bottomAnchor.constraint(equalTo: productScrollView.contentLayoutGuide.bottomAnchor)
//        ])
    }

    private func configureViews() {
        if let imageName = product?.image?.mainImage, let image = UIImage(named: imageName) {
            galleryView.configure(with: image)
        } else {
            galleryView.configure(with: UIImage(named: "placeholder")!)
        }

        if let titleLabelText = product?.name, let weightLabelText = product?.description {
            titleView.configure(with: titleLabelText, weight: weightLabelText)
        } else {
            titleView.configure(with: "Title", weight: "Weight")
        }
    }
}
