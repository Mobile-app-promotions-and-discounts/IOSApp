import UIKit

final class GenericNavigationController: UINavigationController {
    private var roundedBackground = UIView()
    private var clippedView = UIView()
    private var navBarFrame = CGRect()
    private let cornerRadius = CornerRadius.regular.cgFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .cherryMainAccent
        appearence.setBackIndicatorImage(.icBack, transitionMaskImage: .icBack)

        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = appearence
        navigationBar.compactAppearance = appearence

        navigationBar.barStyle = .black

        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .clear
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true

        navigationBar.clipsToBounds = true
        navigationBar.layer.cornerRadius = CornerRadius.regular.cgFloat()
        navigationBar.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        navigationBar.tintColor = .cherryWhite

        roundedBackground.backgroundColor = .cherryMainAccent
        roundedBackground.layer.cornerRadius = cornerRadius
        roundedBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        clippedView.backgroundColor = .clear
        clippedView.clipsToBounds = true
        navigationBar.addSubview(clippedView)
        clippedView.addSubview(roundedBackground)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navBarFrame = CGRect(origin: CGPoint(x: 0,
                                             y: -cornerRadius),
                                 size: CGSize(width: navigationBar.bounds.width,
                                              height: cornerRadius*2))
        roundedBackground.frame = navBarFrame
        let clippedFrame = CGRect(origin: CGPoint(x: navigationBar.bounds.minX,
                                               y: navigationBar.bounds.maxY),
                                   size: CGSize(width: navigationBar.bounds.width,
                                                height: cornerRadius))
        clippedView.frame = clippedFrame
    }
}
