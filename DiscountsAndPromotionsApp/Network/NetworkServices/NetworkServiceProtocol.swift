import Combine
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, parameters: Encodable?) -> AnyPublisher<T, AppError>
}
