import UIKit

final class GenericNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .mainAccent

        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = appearence
        navigationBar.compactAppearance = appearence

        navigationBar.tintColor = .white

        let navBarFrame = CGRect(origin: CGPoint(x: navigationBar.frame.minX, y: navigationBar.frame.maxY - CornerRadius.regular.cgFloat()),
                                 size: CGSize(width: navigationBar.bounds.width,
                                              height: CornerRadius.regular.cgFloat()*2))
        let background = UIView(frame: navBarFrame)
        navigationBar.addSubview(background)
        navigationBar.sendSubviewToBack(background)
        background.backgroundColor = UIColor.mainAccent
        background.layer.cornerRadius = CornerRadius.regular.cgFloat()
        background.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
