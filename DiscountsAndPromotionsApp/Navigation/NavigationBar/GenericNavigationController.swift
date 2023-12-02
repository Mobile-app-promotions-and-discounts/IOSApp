import UIKit

final class GenericNavigationController: UINavigationController {
    private var roundedBackground = UIView()
    private var navBarFrame = CGRect()
    private let cornerRadius = CornerRadius.regular.cgFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .cherryMainAccent

        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = appearence
        navigationBar.compactAppearance = appearence

        navigationBar.tintColor = .cherryWhite

        navigationBar.addSubview(roundedBackground)
        roundedBackground.backgroundColor = UIColor.cherryMainAccent
        roundedBackground.layer.cornerRadius = cornerRadius
        roundedBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    override func viewDidLayoutSubviews() {
        navBarFrame = CGRect(origin: CGPoint(x: navigationBar.bounds.minX,
                                             y: navigationBar.bounds.maxY - cornerRadius),
                                 size: CGSize(width: navigationBar.bounds.width,
                                              height: cornerRadius*2))
        roundedBackground.frame = navBarFrame
        navigationBar.sendSubviewToBack(roundedBackground)
    }
}
