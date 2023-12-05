import Combine
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint, headers: [String: String]?, parameters: [String: String]?) -> AnyPublisher<T, AppError>
}
