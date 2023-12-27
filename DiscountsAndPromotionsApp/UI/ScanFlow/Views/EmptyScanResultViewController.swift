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
        self.hidesBottomBarWhenPushed = true
        setupUI()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBindings() {
        emptyResultView.mainButtonTappedPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.navigateToMainScreen()
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        setBackAction { [weak self] in
            self?.coordinator?.navigateBack()
        }

        view.addSubview(emptyResultView)
        emptyResultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
