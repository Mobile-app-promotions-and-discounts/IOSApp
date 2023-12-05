// import UIKit
//
// extension UIImage {
//    func withVerticallyFlippedOrientation() -> UIImage {
//        var flippedImage = UIImage()
//        if let newCGImage = self.cgImage {
//            flippedImage = UIImage(cgImage: newCGImage, scale: self.scale, orientation: .downMirrored)
//        }
//        return flippedImage
//    }
//
//    func resizedImage(Size newSize: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        self.draw(in: CGRect(origin: .zero, size: newSize))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage
//    }
// }
