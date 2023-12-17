import Combine
import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    func request<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
        print(statusCode)
        switch statusCode {
        case 200..<300:
            do {
                print(data)
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AppError.parsingError
            }
        default:
            throw AppError.networkError
        }
    }
}
