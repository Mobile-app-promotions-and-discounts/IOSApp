import UIKit

class CherryCustomViewController: UIViewController {
    lazy var backButton = { [weak self] in
        guard let self else {
            return UIButton()
        }
        let backButton = UIButton(type: .system)
        backButton.tintColor = .cherryGrayBlue
        backButton.setImage(.icBack, for: .normal)
        backButton.addTarget(self,
                             action: #selector(defaultBackAction),
                             for: .touchUpInside)
        backButton.contentMode = .right
        return backButton
    }()

    private lazy var backAction: () -> Void = { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        setupUI()
    }

    func setBackAction(action: @escaping () -> Void) {
        backAction = action
    }

    private func setupUI() {
        view.backgroundColor = .cherryLightBlue
        navigationItem.hidesBackButton = true
        if self != navigationController?.viewControllers[0] {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }

    @objc
    private func defaultBackAction() {
        backAction()
    }

    func showBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
