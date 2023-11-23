import UIKit

extension UIImage {
    func withVerticallyFlippedOrientation() -> UIImage {
        var flippedImage = UIImage()
        if let newCGImage = self.cgImage {
            flippedImage = UIImage(cgImage: newCGImage, scale: self.scale, orientation: .downMirrored)
        }
        return flippedImage
    }
}
