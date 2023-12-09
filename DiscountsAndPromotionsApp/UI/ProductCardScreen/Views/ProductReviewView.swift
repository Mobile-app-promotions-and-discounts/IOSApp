import UIKit
import SnapKit
import Combine

class ProductReviewView: UIView {
    var viewModel: ProductReviewViewModelProtocol? {
        didSet {
            setupBindings()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let titleLabel = UILabel()
    private let starsStackView = UIStackView()
    private let reviewTextView = UITextView()
    private let submitButton = UIButton()

    private var rating: Int = 1
    private var previousText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupBindings()
        setupTitleLabel()
        setupStarsStackView()
        setupReviewTextView()
        setupTextView()
        setupSubmitButton()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        backgroundColor = .cherryLightBlue
        layer.cornerRadius = CornerRadius.large.cgFloat()
    }

    private func setupTitleLabel() {
        titleLabel.text = "Как Вам этот товар?"
        titleLabel.font = CherryFonts.headerLarge
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
        reviewTextView.textColor = .cherryGrayBlue
        reviewTextView.backgroundColor = .cherryLightBlue
        reviewTextView.text = "Ваш отзыв"
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        reviewTextView.isScrollEnabled = false
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
        reviewTextView.inputAccessoryView = toolbar
    }

    private func setupSubmitButton() {
        submitButton.setImage(UIImage(named: "send"), for: .normal)
        addSubview(submitButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(27)
        }

        starsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.width.equalTo(152)
        }

        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(starsStackView.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
            make.height.greaterThanOrEqualTo(79)
        }

        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(reviewTextView.snp.trailing).offset(-8)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.height.width.equalTo(24)
        }
    }

    private func setupBindings() {
        submitButton.publisher(for: .touchUpInside)
            .map { [weak self] _ in (self?.viewModel?.rating.value ?? 1, self?.reviewTextView.text ?? "")
            }
            .sink {[weak self] rating, reviewText in
                self?.viewModel?.submitReview.send((rating, reviewText))
            }
            .store(in: &cancellables)

        reviewTextView.beginEditingPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.reviewTextView.text == "Ваш отзыв" {
                    self.previousText = self.reviewTextView.text
                    self.reviewTextView.text = nil
                    self.reviewTextView.textColor = UIColor.black
                }
            }
            .store(in: &cancellables)

        reviewTextView.endEditingPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.reviewTextView.text.isEmpty {
                    self.reviewTextView.text = "Ваш отзыв"
                    self.reviewTextView.textColor = UIColor.lightGray
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

    @objc private func cancelButtonTapped() {
        // Действие для кнопки "Отмена"
        reviewTextView.text = previousText
        reviewTextView.resignFirstResponder()
    }

    @objc private func doneButtonTapped() {
        // Действие для кнопки "Готово"
        reviewTextView.resignFirstResponder()
    }
}
