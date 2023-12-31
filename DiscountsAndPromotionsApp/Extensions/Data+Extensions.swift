import Foundation

extension Data {
    func printAsJSON() {
        if let theJSONData = try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary {
            var swiftDict = theJSONData as? [String: Any] ?? [:]
            swiftDict.printAsJSON()
        }
    }
}
