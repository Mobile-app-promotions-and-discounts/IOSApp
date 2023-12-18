import Combine
import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(for urlRequest: URLRequest) async throws -> T
    func request(for urlRequest: URLRequest) async throws -> Result<URLResponse, AppError>
}
