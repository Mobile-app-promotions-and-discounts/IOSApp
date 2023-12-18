import Combine
import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, additionalPath: String?, headers: [String: String]?, parameters: [String: Any]?) -> AnyPublisher<T, AppError>

    func requestWithEmptyResponse(endpoint: Endpoint, additionalPath: String?, headers: [String: String]?, parameters: [String: String]?) -> AnyPublisher<Data, AppError>
}
