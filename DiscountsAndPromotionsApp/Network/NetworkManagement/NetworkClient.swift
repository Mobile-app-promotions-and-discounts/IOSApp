import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    func request<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
        print(statusCode)
        data.printAsJSON()
        switch statusCode {
        case 200..<300:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AppError.parsingError
            }
        default:
            do {
                let error = try decoder.decode(NetworkErrorDescriptionModel.self, from: data)
                throw AppError.customError("\(error)")
            } catch {
                throw AppError.networkError(code: statusCode)
            }
        }
    }

    func request(for urlRequest: URLRequest) async throws -> URLResponse {
        let (data, response) = try await session.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400
        print(statusCode)
        data.printAsJSON()

        switch statusCode {
        case 200..<300:
            return response
        default:
            do {
                let error = try decoder.decode(NetworkErrorDescriptionModel.self, from: data)
                throw AppError.customError("\(error)")
            } catch {
                throw AppError.networkError(code: statusCode)
            }
        }
    }
}
