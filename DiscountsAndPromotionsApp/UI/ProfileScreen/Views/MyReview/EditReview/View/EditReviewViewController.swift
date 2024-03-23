//
//  EditReviewViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Александр Кудряшов on 22.03.2024.
//

import UIKit

class EditReviewViewController: UIViewController {

    // MARK: - Constants
    private enum Const {
        static let topInset: CGFloat = 24
        static let horizInset: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        enum CloseButton {
            static let heightWidth: CGFloat = 24
        }
        enum RatingView {
            static let topOffset: CGFloat = 20
        }
        enum PhotoImageView {
            static let width: CGFloat = 76
        }
        enum StackView {
            static let topOffset: CGFloat = 8
            static let spacing: CGFloat = 8
            static let height: CGFloat = 99
        }
        enum EditButton {
            static let height: CGFloat = 51
            static let topOffset: CGFloat = 20
        }
    }

    // MARK: - Public properies
    var coordinator: ProfileScreenCoordinator?
    let viewModel: EditReviewViewModelProtocol

    // MARK: - Private properies
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.Edit.Review.editingReview
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        label.textAlignment = .left
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeRectangle, for: .normal)
        button.tintColor = .cherryBlack
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()

    private lazy var ratingView = TouchRatingView(rating: viewModel.model.value.rating,
                                                  maxRating: 5)

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = viewModel.model.value.image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Const.cornerRadius
        return imageView
    }()

    private lazy var commentTextView: ReviewTextView = {
        let textView = ReviewTextView(delegate: self,
                                      text: viewModel.model.value.comment) { [weak self] in
            self?.addPhotoAction()
        }
        textView.layer.cornerRadius = Const.cornerRadius
        return textView
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView,commentTextView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Const.StackView.spacing
        return stackView
    }()

    private lazy var editButton: SignButton = {
        let button = SignButton(title: L10n.Profile.Edit.Review.editReview)
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecicle
    init(viewModel: EditReviewViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    // MARK: - Pivate methods
    @objc
    private func closeView() {

    }

    private func addPhotoAction() {
        // TODO: - не реализовано на беке
    }

    @objc
    private func editAction() {
        editButton.isShowIndicator = true
        viewModel.editReview()
        // временное решение для проверки
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.editButton.isShowIndicator = false
        }
    }

    // MARK: - Private layout setting
    private func setupView() {
        view.backgroundColor = .cherryWhite
    }

    private func setupConstraints() {
        [titleLabel,
         closeButton,
         ratingView,
         commentStackView,
         editButton].forEach { view.addSubview($0)}

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(Const.topInset)
            $0.leading.equalToSuperview()
                .inset(Const.horizInset)
        }

        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
                .inset(Const.horizInset)
            $0.height.width.equalTo(Const.CloseButton.heightWidth)
        }

        ratingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(Const.RatingView.topOffset)
            $0.centerX.equalToSuperview()
        }

        photoImageView.snp.makeConstraints {
            $0.width.equalTo(Const.PhotoImageView.width)
        }

        commentStackView.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom)
                .offset(Const.StackView.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.horizInset)
            $0.height.equalTo(Const.StackView.height)
        }

        editButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(Const.horizInset)
            $0.height.equalTo(Const.EditButton.height)
            $0.top.equalTo(commentStackView.snp.bottom)
                .offset(Const.EditButton.topOffset)
        }

    }

}

// MARK: - UITextViewDelegate
extension EditReviewViewController: UITextViewDelegate {

}
