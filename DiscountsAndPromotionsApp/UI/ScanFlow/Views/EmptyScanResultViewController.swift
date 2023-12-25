import UIKit
import SnapKit
import Combine

final class EmptyScanResultViewController: ScannerEnabledViewController {
    weak var coordinator: ScanFlowCoordinator?

    private let emptyResultView: EmptyOnScreenView
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.emptyResultView = EmptyOnScreenView(state: .noResult)
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    private func setupBindings() {
        emptyResultView.mainButtonTappedPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.navigateToMainScreen()
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        view.addSubview(emptyResultView)

        emptyResultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
