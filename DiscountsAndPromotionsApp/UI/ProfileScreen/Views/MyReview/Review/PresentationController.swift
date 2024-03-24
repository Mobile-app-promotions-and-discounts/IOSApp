import UIKit

class PresentationController: UIPresentationController {

    private var dimmingView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var keyboardHight: CGFloat = 0

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        setupDimmingView()
        notificationKeyboard()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let originPoint = CGPoint(x: 0,
                                  y: self.containerView!.frame.height - 291 - keyboardHight)
        let viewSize = CGSize(width: self.containerView!.frame.width,
                              height: 291 + keyboardHight)

        return CGRect(origin: originPoint,
                      size: viewSize)
    }

    override func presentationTransitionWillBegin() {
        self.dimmingView.alpha = 0
        self.containerView?.addSubview(dimmingView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0.6
        }, completion: { (_) in })
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0
        }, completion: { (_) in
            self.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 10)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }

    private func setupDimmingView() {
      dimmingView = UIView()
      dimmingView.translatesAutoresizingMaskIntoConstraints = false
      dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
      dimmingView.alpha = 0.0

      let recognizer = UITapGestureRecognizer(target: self,
                                              action: #selector(handleTap(recognizer:)))
      dimmingView.addGestureRecognizer(recognizer)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
      presentingViewController.dismiss(animated: true)
    }

    // клавиатура
    private func notificationKeyboard() {
        NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),
                                               name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),
                                               name:UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        keyboardHight = frame.height
        containerView?.setNeedsLayout()

    }

    @objc func keyboardWillHide(notification: Notification) {
        keyboardHight = .zero
        containerView?.setNeedsLayout()
    }

}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
