import SnapKit
import UIKit

final class AuthViewController: UIViewController {
    
    var coordinator: AuthCoordinator?
    
    private lazy var cherryiesImageView: UIImageView = {
        let imageView = UIImageView(image: .cherries)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coordinator?.navigateLoginViewController(from: self)
    }
    
    private func setupView() {
        view.backgroundColor = .cherryLightBlue
    }
    
    private func setupConstraints() {
        view.addSubview(cherryiesImageView)
        
        cherryiesImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension AuthViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PartialSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class PartialSizePresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 4.3, width: bounds.width, height: bounds.height / 1.3)
    }
}
