import UIKit

enum CherryGradient {
    case yellowBlue,
         yellowRed,
         yellowYellow,
         yellowPurple,
         yellowOrange,
         yellowGreen
}

extension CALayer {
    static func makeGradiet(gradient: CherryGradient, for view: UIView) {
        var baseColor: UIColor = .gradientBase
        var accentColor: UIColor = .cherryWhite
        
        switch gradient {
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
        
        let layer0 = CAGradientLayer()
        layer0.colors = [
        baseColor.cgColor,
        accentColor.cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.81, b: 1.05, c: -1.05, d: 0.45, tx: 0.56, ty: -0.22))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
    }
}
