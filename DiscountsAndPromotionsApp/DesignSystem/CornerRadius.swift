import Foundation

enum CornerRadius: Int {
    case regular = 10

    func cgFloat() -> CGFloat {
        CGFloat(self.rawValue)
    }
}
