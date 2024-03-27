import Combine
import SnapKit
import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    private let titleName: String
    private let webViewURL: WebViewURL
    private var backButtonAction: (() -> Void)?
    weak var coordinator: WebViewCoordinator?

    private let viewState = CurrentValueSubject<ViewState, Never>(.empty)
    private var cancellables = Set<AnyCancellable>()
    private var webViewProgressObservation: NSKeyValueObservation?

    private lazy var backButton = UIBarButtonItem(
        image: UIImage(named: "ic_back")?.withTintColor(.cherryBlack).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: self,
        action: #selector(buttonAction)
    )

    private lazy var webView = WKWebView()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .cherryBlack
        return progressView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .cherryMainAccent
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    init(titleName: String? = nil,
         webViewURL: WebViewURL,
         backButtonAction: ( () -> Void)? = nil) {
        self.titleName = titleName ?? webViewURL.name
        self.webViewURL = webViewURL
        self.backButtonAction = backButtonAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupConstraints()
        observeWebView()
        loadWebView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }

    private func observeWebView() {
        webViewProgressObservation = webView.observe(\.estimatedProgress,
                                                      options: [.new]) { [weak self] _, change in
            if let newValue = change.newValue {
                self?.updateProgressValue(newValue)
            }
        }
    }

    private func bindingOn() {
        viewState.sink { [weak self] isLoading in
            self?.showIsActivityIndicator(isLoading)
        }.store(in: &cancellables)

    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    private func loadWebView() {
        guard let url = URL(string: webViewURL.rawValue) else { return }
        let request = URLRequest(url: url)
        webView.load(request)

        // Если через 5 секунд не начинается загрузка, выводим ошибку о проблеме с сетью
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [ weak self ] in
            self?.checkInternet()
        }
    }

    private func checkInternet() {
        if viewState.value == .empty {
            ErrorHandler.handle(error: AppError.networkError(code: nil))
            webView.stopLoading()
        }
    }

    private func updateProgressValue(_ progress: Double) {
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(progress)
            if progress < 1 {
                self.progressView.isHidden = false
            } else {
                self.progressView.isHidden = true
            }
        }
    }

    private func showIsActivityIndicator(_ viewState: ViewState) {
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
        case .dataPresent:
            activityIndicator.stopAnimating()
        case .empty:
            activityIndicator.stopAnimating()
        }
    }

    @objc private func buttonAction() {
        guard let backButtonAction else {
            coordinator?.dismissWebView(self)
            return
        }
        backButtonAction()
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        webView.navigationDelegate = self
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backButton
        self.title = titleName
        if let navigationBar = navigationController?.navigationBar {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.cherryBlack,
                NSAttributedString.Key.font: CherryFonts.headerLarge as Any
            ]
            navigationBar.titleTextAttributes = attributes
        }
    }

    private func setupConstraints() {
        [progressView,
         webView,
         activityIndicator].forEach { view.addSubview($0) }

        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .offset(Const.Progressview.topOffset)
            $0.height.equalTo(Const.Progressview.height)
            $0.trailing.leading.equalToSuperview()
        }

        webView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

    }

    private enum Const {
        enum Progressview {
            static let topOffset: CGFloat = 2
            static let height: CGFloat = 2
        }
    }

}

extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        viewState.send(.loading)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewState.send(.dataPresent)
    }

}
