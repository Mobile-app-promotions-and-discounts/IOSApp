import Foundation

final class AboutAppViewModel: AboutAppViewModelProtocol {

    private let webViews: [WebViewURL]

    init(webViews: [WebViewURL] = WebViewURL.allCases) {
        self.webViews = webViews
    }

    func getUrlsCount() -> Int {
        webViews.count
    }

    func getWebView(row: Int) -> WebViewURL {
        return webViews[row]
    }

}
