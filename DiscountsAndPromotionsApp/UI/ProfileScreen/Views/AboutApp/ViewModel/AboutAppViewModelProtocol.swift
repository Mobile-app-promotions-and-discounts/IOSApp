import Foundation

protocol AboutAppViewModelProtocol {
    func getUrlsCount() -> Int
    func getWebView(row: Int) -> WebViewURL
}
