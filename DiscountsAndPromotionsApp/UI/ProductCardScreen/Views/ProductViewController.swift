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

    private lazy var productScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = contentSize
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = contentSize
        return view
    }()

        private var contentSize: CGSize {
            CGSize(width: view.frame.width, height: view.frame.height + 300)
        }

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
        view.addSubview(productScrollView)
        productScrollView.addSubview(contentView)
        contentView.addSubview(galleryView)
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        // Ограничения для ScrollView
        NSLayoutConstraint.activate([
            productScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            productScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: productScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: productScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: productScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: productScrollView.bottomAnchor)
        ])

        // Ограничения для GalleryView
        NSLayoutConstraint.activate([
            galleryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            galleryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            galleryView.heightAnchor.constraint(equalToConstant: 316),
            galleryView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
            // Высота должна быть задана
        ])

//        // Ограничения для TitleView
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: galleryView.bottomAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
//            titleView.trailingAnchor.constraint(equalTo: productScrollView.frameLayoutGuide.trailingAnchor),
//            titleView.heightAnchor.constraint(equalToConstant: 100) // Примерная высота, если не определена внутри TitleView
        ])
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
