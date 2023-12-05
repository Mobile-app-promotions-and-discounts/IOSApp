import Combine
import Foundation

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let decoder = JSONDecoder()

    private init() {}

    func request<T: Decodable>(endpoint: Endpoint, headers: [String: String]?, parameters: [String: String]?) -> AnyPublisher<T, AppError> {
        guard let url = URL(string: endpoint.URL) else {
            return Fail(error: AppError.networkError).eraseToAnyPublisher()
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

        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw AppError.customError("Request failed")
                }
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> AppError in
                if error is DecodingError {
                    return AppError.customError("Decoding error")
                } else {
                    return AppError.networkError
                }
            }
            .eraseToAnyPublisher()

        return publisher
    }
}
