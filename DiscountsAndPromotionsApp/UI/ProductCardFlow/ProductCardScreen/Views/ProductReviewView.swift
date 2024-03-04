import UIKit
import SnapKit
import Combine

final class ProductReviewView: UIView {
    enum ReviewState {
        case fetchingReview
        case notReviewed
        case reviewed
    }

    var viewModel: ProductReviewViewModelProtocol? {
        didSet {
            setupBindings()
            state = .fetchingReview
        }
    }

    var state: ReviewState = .fetchingReview {
        didSet {
            configureUI()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let titleLabel = UILabel()
    private let starsStackView = UIStackView()
    private let reviewTextView = UITextView()
    private let attachButton = UIButton(type: .system)
    private let submitButton = UIButton(type: .system)

    private var rating: Int = 0
    private var productName: String = ""
    private var previousText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupInnerBindings()
        setupTitleLabel()
        setupStarsStackView()
        setupReviewTextView()
        setupTextView()
        setupSubmitButton()
        setupAttachButton()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    // отрисовка интерфейса когда меняется состояние
    private func configureUI() {
        switch state {
        case .fetchingReview:
            configFetchingReview()
            viewModel?.fetchReviewText()
        case .notReviewed:
            configNotReviewed()
        case .reviewed:
            configReviewed()
        }
    }

    private func configFetchingReview() {
        updateHeader()
        reviewTextView.backgroundColor = .cherryLightBlue
        reviewTextView.textColor = .cherryGrayBlue.withAlphaComponent(0.5)
        reviewTextView.isUserInteractionEnabled = false
        submitButton.isUserInteractionEnabled = false
        submitButton.alpha = 0.5
        starsStackView.isUserInteractionEnabled = false
        starsStackView.alpha = 0.5
    }

    private func configNotReviewed() {
        updateHeader()
        reviewTextView.backgroundColor = .cherryLightBlue
        reviewTextView.text = "Ваш отзыв"
        reviewTextView.textColor = UIColor.cherryGrayBlue.withAlphaComponent(1)
        reviewTextView.isUserInteractionEnabled = true
        submitButton.isUserInteractionEnabled = true
        submitButton.alpha = 1
        starsStackView.isUserInteractionEnabled = true
        starsStackView.alpha = 1
    }

    private func configReviewed() {
        updateHeader()
        reviewTextView.backgroundColor = .clear
        reviewTextView.text = viewModel?.reviewText.value
        reviewTextView.textColor = .cherryBlack.withAlphaComponent(1)
        reviewTextView.isUserInteractionEnabled = false
        submitButton.isUserInteractionEnabled = false
        submitButton.alpha = 0
        if let rating = viewModel?.rating.value {
            updateStarRating(rating)
        }
        starsStackView.isUserInteractionEnabled = false
        starsStackView.alpha = 1
    }

    private func updateHeader() {
        switch state {
        case .fetchingReview:
            titleLabel.text = "Как вам «\(productName)»?"
        case .notReviewed:
            titleLabel.text = "Как вам «\(productName)»?"
        case .reviewed:
            titleLabel.text = "Отзыв на «\(productName)»"
        }
    }

    // MARK: - первоначальная настройка UI
    private func configureView() {
        backgroundColor = .cherryLightBlue
        layer.cornerRadius = CornerRadius.large.cgFloat()
    }

    private func setupTitleLabel() {
        titleLabel.text = "Как Вам этот товар?"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .cherryBlack
        titleLabel.font = CherryFonts.headerMedium
        addSubview(titleLabel)
    }

    private func setupStarsStackView() {
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        for index in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(named: "ic_bigStar"), for: .normal)
            starButton.tintColor = .black
            starsStackView.addArrangedSubview(starButton)

            starButton.publisher(for: .touchUpInside)
                .map { _ in index + 1 }
                .sink { [weak self] rating in
                    self?.viewModel?.rating.send(rating)
                    self?.updateStarRating(rating)
                }
                .store(in: &cancellables)
        }
        addSubview(starsStackView)
    }

    private func setupReviewTextView() {
        reviewTextView.font = CherryFonts.textMedium
        reviewTextView.textColor = .cherryStarGrayBlue
        reviewTextView.backgroundColor = .cherryLightBlueCard
        reviewTextView.text = "Ваш отзыв"
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        reviewTextView.isScrollEnabled = false
        reviewTextView.contentInset.right = 44
        addSubview(reviewTextView)
    }

    private func setupTextView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))

            toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            self.reviewTextView.inputAccessoryView = toolbar
    }

    private func setupAttachButton() {
        attachButton.setImage(UIImage(named: "ic_attach"), for: .normal)
//        убрал пока не реализовано на бэке
//        addSubview(attachButton)
    }

    private func setupSubmitButton() {
        submitButton.setImage(UIImage(named: "ic_send")?.withRenderingMode(.alwaysOriginal), for: .normal)
        submitButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        addSubview(submitButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
        }

        starsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.width.equalTo(152)
        }

        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(starsStackView.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
            make.height.greaterThanOrEqualTo(79)
        }

        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(reviewTextView)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.height.width.equalTo(44)
        }

//        убрал пока не реализовано на бэке
//        attachButton.snp.makeConstraints { make in
//            make.trailing.equalTo(reviewTextView).offset(-8)
//            make.bottom.equalTo(submitButton.snp.top).offset(-16)
//            make.height.width.equalTo(24)
//        }
    }

    // MARK: - Bindings
    private func setupBindings() {
        viewModel?.didPublishReview
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didPublishReview in
                if didPublishReview {
                    self?.state = .fetchingReview
                }
            }
            .store(in: &cancellables)

        viewModel?.didFetchReview
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didFetchReview in
                guard let self,
                let reviewText = viewModel?.reviewText.value else { return }
                if didFetchReview {
                    self.state = reviewText.isEmpty ? .notReviewed : .reviewed
                }
            }
            .store(in: &cancellables)
    }

    private func setupInnerBindings() {
        reviewTextView.beginEditingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.reviewTextView.text == "Ваш отзыв" {
                    self.previousText = self.reviewTextView.text
                    self.reviewTextView.text = nil
                    self.reviewTextView.textColor = UIColor.cherryBlack
                } else {
                    self.reviewTextView.textColor = UIColor.cherryBlack
                }
            }
            .store(in: &cancellables)

        reviewTextView.endEditingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.reviewTextView.text.isEmpty {
                    self.reviewTextView.text = "Ваш отзыв"
                    self.reviewTextView.textColor = UIColor.cherryGrayBlue
                }
            }
            .store(in: &cancellables)
    }

    private func updateStarRating(_ rating: Int) {
        for (index, button) in starsStackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                button.setImage(UIImage(named: index < rating ? "ic_bigStarFill" : "ic_bigStar"), for: .normal)
                button.tintColor = index < rating ? .cherryYellow : .cherryGray
            }
        }
    }

    func configure(with name: String) {
        productName = name
        updateHeader()
    }

    // MARK: - Actions

    @objc private func cancelButtonTapped() {
        // Действие для кнопки "Отмена"
        reviewTextView.text = previousText
        reviewTextView.resignFirstResponder()
    }

    @objc private func doneButtonTapped() {
        // Действие для кнопки "Готово"
        reviewTextView.resignFirstResponder()
    }

    @objc private func sendButtonTapped() {
        if let reviewRating = viewModel?.rating.value,
           reviewRating != 0,
           !reviewTextView.text.isEmpty {
            viewModel?.submitReview.send((reviewRating, reviewTextView.text))
            state = .fetchingReview
            }
        }
}
