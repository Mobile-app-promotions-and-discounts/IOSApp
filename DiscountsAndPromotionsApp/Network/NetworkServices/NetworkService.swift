import Combine
import Foundation

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, parameters: Encodable? = nil) -> AnyPublisher<T, AppError> {
            guard let url = URL(string: endpoint.URL) else {
                return Fail(error: AppError.networkError).eraseToAnyPublisher()
            }
            var urlRequest = URLRequest(url: url)

            if let parameters = parameters {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    let jsonData = try JSONEncoder().encode(parameters)
                    urlRequest.httpBody = jsonData
                } catch {
                    return Fail(error: AppError.parsingError).eraseToAnyPublisher()
                }
            }
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    if let httpResponse = response as? HTTPURLResponse,
                       (200..<300).contains(httpResponse.statusCode) {
                        return data
                    } else {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                        throw AppError.customError("Request failed with status code: \(statusCode)")
                    }
                }
                .decode(type: NetworkResponseWrapper<T>.self, decoder: JSONDecoder())
                .tryMap { (responseWrapper) -> T in
                    guard let status = responseWrapper.status else {
                        throw AppError.customError("Response missing status.")
                    }
                    switch status {
                    case 200:
                        guard let data = responseWrapper.data else {
                            throw AppError.customError("Response missing data.")
                        }
                        return data
                    default:
                        let message = responseWrapper.message ?? "An error occurred."
                        throw AppError.customError("Request failed with message: \(message)")
                    }
                }
                .mapError { error -> AppError in
                    if error is DecodingError {
                        return AppError.customError("decoding error")
                    } else {
                        return AppError.networkError
                    }
                }
                .eraseToAnyPublisher()
        }
}
