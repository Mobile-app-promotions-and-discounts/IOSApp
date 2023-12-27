import Foundation

protocol NetworkRequestConstructorProtocol {
    func makeRequest(endpoint: Endpoint,
                     additionalPath: String?,
                     headers: [String: String]?,
                     parameters: [String: Any]?) -> URLRequest?
}

final class NetworkRequestConstructor: NetworkRequestConstructorProtocol {
    static let shared = NetworkRequestConstructor()

    func makeRequest(endpoint: Endpoint,
                     additionalPath: String?,
                     headers: [String: String]?,
                     parameters: [String: Any]?) -> URLRequest? {
        var extraPath = ""
        if let additionalPath {
            extraPath = additionalPath
        }
        guard let url = URL(string: endpoint.URL + extraPath) else {
            print("invalid URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters {
            let bodyData = try? JSONSerialization.data(
                withJSONObject: parameters,
                options: []
            )
            request.httpBody = bodyData
        }
        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
