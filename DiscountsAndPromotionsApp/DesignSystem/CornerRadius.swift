import Foundation

enum CornerRadius: Int {
    case regular = 10
    case small = 8
    case large = 12

    func cgFloat() -> CGFloat {
        CGFloat(self.rawValue)
    }
}
