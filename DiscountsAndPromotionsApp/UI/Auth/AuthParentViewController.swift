//
//  AuthParentViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Александр Кудряшов on 02.02.2024.
//

import UIKit

class AuthParentViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private let titleName: String?
    private let isAddBackButton: Bool

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleName ?? ""
        label.font = CherryFonts.titleExtraLarge
        label.setLineSpacing(lineHeightMultiple: 0.9)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .cherryBlack
        return label
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ic_back") ?? UIImage()
        button.setImage(image, for: .normal)
        button.tintColor = .cherryBlack
        return button
    }()

    init(title: String? = nil, isAddBackButton: Bool = false) {
        self.titleName = title
        self.isAddBackButton = isAddBackButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupConstraints() {
        if let titleName = self.titleName {
            titleLabel.text = titleName

            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
                    .inset(32)
                $0.leading.trailing.equalToSuperview()
                    .inset(Const.TitleLable.horizontalInsert)
            }
        }

        if isAddBackButton {
            view.addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.top.equalToSuperview()
                    .offset(Const.BackButton.topOffset)
                $0.leading.equalToSuperview()
                    .offset(Const.BackButton.leadingOffset)
                $0.height.width.equalTo(Const.BackButton.heightWight)
            }
        }
    }

    private enum Const {
        enum View {
            static let cornerRadius: CGFloat = 12
        }
        enum TitleLable {
            static let topOffset: CGFloat = 32
            static let horizontalInsert: CGFloat = 65
        }
        enum BackButton {
            static let leadingOffset: CGFloat = 16
            static let topOffset: CGFloat = 35
            static let heightWight: CGFloat = 24
        }
    }

}
