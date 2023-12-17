import Combine
import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    private let requestConstructor: NetworkRequestConstructor
    
    init(requestConstructor: NetworkRequestConstructor = NetworkRequestConstructor.shared) {
        self.requestConstructor = requestConstructor
    }

//    func request<T: Decodable>(endpoint: Endpoint,
//                               additionalPath: String?,
//                               headers: [String: String]?,
//                               parameters: [String: Any]?) -> AnyPublisher<T, AppError> {
//        var extraPath = ""
//        if let additionalPath {
//            extraPath = additionalPath
//        }
//        guard let url = URL(string: endpoint.URL + extraPath) else {
//            return Fail(error: AppError.networkError).eraseToAnyPublisher()
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let parameters {
//            let bodyData = try? JSONSerialization.data(
//                withJSONObject: parameters,
//                options: []
//            )
//            request.httpBody = bodyData
//        }
//        if let headers {
//            for (key, value) in headers {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//
//        let publisher = URLSession.shared
//            .dataTaskPublisher(for: request)
//            .receive(on: DispatchQueue.main)
//            .tryMap { (data, response) -> Data in
//                if let httpResponse = response as? HTTPURLResponse,
//                   (200..<300).contains(httpResponse.statusCode) {
//                    return data
//                } else {
//                    throw AppError.customError("Request failed")
//                }
//            }
//            .map { data in
//                print(data)
//                return data
//            }
//            .decode(type: T.self, decoder: decoder)
//            .mapError { error -> AppError in
//                if error is DecodingError {
//                    return AppError.customError("Decoding error")
//                } else {
//                    return AppError.networkError
//                }
//            }
//            .eraseToAnyPublisher()
//
//        return publisher
//    }
    
    func request<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
        switch statusCode {
        case 200..<300:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AppError.parsingError
            }
        default:
            throw AppError.networkError
        }
    }

//    func requestWithEmptyResponse(endpoint: Endpoint,
//                                  additionalPath: String?,
//                                  headers: [String: String]?,
//                                  parameters: [String: String]?) -> AnyPublisher<Data, AppError> {
//        var extraPath = ""
//        if let additionalPath {
//            extraPath = additionalPath
//        }
//        guard let url = URL(string: endpoint.URL + extraPath + "/") else {
//            return Fail(error: AppError.networkError).eraseToAnyPublisher()
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let parameters {
//            let bodyData = try? JSONSerialization.data(
//                withJSONObject: parameters,
//                options: []
//            )
//            request.httpBody = bodyData
//        }
//        if let headers {
//            for (key, value) in headers {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//
//        let publisher = URLSession.shared
//            .dataTaskPublisher(for: request)
//            .receive(on: DispatchQueue.main)
//            .tryMap { (data, response) -> Data in
//                if let httpResponse = response as? HTTPURLResponse,
//                   (200..<300).contains(httpResponse.statusCode) {
//                    return data
//                } else {
//                    throw AppError.customError("Request failed")
//                }
//            }
//            .mapError { error -> AppError in
//                if error is DecodingError {
//                    return AppError.customError("Decoding error")
//                } else {
//                    return AppError.networkError
//                }
//            }
//            .eraseToAnyPublisher()
//
//        return publisher
//    }
}
