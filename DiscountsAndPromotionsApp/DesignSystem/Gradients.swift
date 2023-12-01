import UIKit

enum CherryGradient {
    case yellowBlue,
         yellowRed,
         yellowYellow,
         yellowPurple,
         yellowOrange,
         yellowGreen

    // метод необходимо вызвать ДО добавления subview, иначе градиент закроет их собой
    func makeGradiet(for view: UIView) {
        let baseColor: UIColor = .gradientBase
        var accentColor: UIColor = .cherryWhite

        switch self {
        case .yellowBlue:
            accentColor = .gradientBlue
        case .yellowGreen:
            accentColor = .gradientGreen
        case .yellowOrange:
            accentColor = .gradientOrange
        case .yellowPurple:
            accentColor = .gradientPurple
        case .yellowRed:
            accentColor = .gradientRed
        case .yellowYellow:
            accentColor = .gradientYellow
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [baseColor.cgColor,
                         accentColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 0.81, b: 1.05, c: -1.05, d: 0.45, tx: 0.56, ty: -0.22)
        )
        gradientLayer.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width,
                                            dy: -0.5*view.bounds.size.height)
        gradientLayer.position = view.center
        view.layer.addSublayer(gradientLayer)
    }
}
