import Combine
import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, headers: [String: String]?, parameters: [String: String]?) -> AnyPublisher<T, AppError>
}
