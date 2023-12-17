import Combine
import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(for urlRequest: URLRequest) async throws -> T
}
