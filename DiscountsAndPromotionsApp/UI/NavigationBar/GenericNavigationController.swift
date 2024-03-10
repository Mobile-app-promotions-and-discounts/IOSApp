import UIKit

final class GenericNavigationController: UINavigationController {
    var scanCoordinator: ScanFlowCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Проверяем, изменилась ли цветовая схема
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupNavBar()
        }
    }

    private func setupNavBar() {
        let imageSize = CGSize(width: navigationBar.frame.width, height: navigationBar.frame.width)
        let image = makeNavBackground(size: imageSize,
                                      color: .cherryNavBarWhite,
                                      cornerRadius: CornerRadius.regular.cgFloat())

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundImage = image
        standardAppearance.backgroundImageContentMode = .bottom
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cherryWhite]

        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = standardAppearance
        navigationBar.tintColor = .clear

        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOpacity = 0.1
        navigationBar.layer.shadowRadius = 10
    }

    private func makeNavBackground(size: CGSize, color: UIColor, cornerRadius: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            context.cgContext.addPath(path.cgPath)
            context.cgContext.clip()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
