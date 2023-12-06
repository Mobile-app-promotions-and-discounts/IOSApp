import Combine
import Foundation

protocol ProfileNetworkServiceProtocol {
    func fetchUser()
}

final class ProfileNetworkService: ProfileNetworkServiceProtocol {
    static let shared = ProfileNetworkService()

    private var networkClient: NetworkClientProtocol
    private var subscriptions = Set<AnyCancellable>()

    init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }

    func fetchUser() {
        let publisher: AnyPublisher<UserResponseModel, AppError> = networkClient.request(endpoint: .getUser, headers: NetworkBaseConfiguration.tokenHeader(), parameters: nil)

        publisher.sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] user in
            print(user)
        }
        .store(in: &subscriptions)
    }
}
