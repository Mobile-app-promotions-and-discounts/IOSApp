import UIKit

final class GenericNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    private func setupNavBar() {
        let imageSize = CGSize(width: navigationBar.frame.width, height: navigationBar.frame.width)
        let image = makeNavBackground(size: imageSize,
                                      color: .cherryMainAccent,
                                      cornerRadius: CornerRadius.regular.cgFloat())

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundImage = image
        standardAppearance.backgroundImageContentMode = .bottom

        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = standardAppearance
        navigationBar.tintColor = .cherryWhite
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
