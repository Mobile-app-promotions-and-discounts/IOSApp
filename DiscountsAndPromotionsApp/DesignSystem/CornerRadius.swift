import Foundation

enum CornerRadius: Int {
    case small = 8
    case regular = 10
    case large = 12

    func cgFloat() -> CGFloat {
        CGFloat(self.rawValue)
    }
}
