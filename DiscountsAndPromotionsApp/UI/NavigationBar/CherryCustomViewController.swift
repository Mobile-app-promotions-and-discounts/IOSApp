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
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cherryBlack]
        if self != navigationController?.viewControllers[0] {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.cherryWhite

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.cherryBlack,
            .font: CherryFonts.headerMedium as Any
        ]
        standardAppearance.titleTextAttributes = titleAttributes

        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.compactAppearance = standardAppearance
    }

    @objc
    private func defaultBackAction() {
        backAction()
    }

    func showBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
