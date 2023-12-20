import Combine
import Foundation

protocol StoreNetworkServiceProtocol {
    var storeListUpdate: PassthroughSubject<StoresResponseModel, Never> { get }
    var chainListUpdate: PassthroughSubject<StoreChainsResponseModel, Never> { get }

    func fetchStores(page: Int)
    func fetchChains()
}

final class StoreNetworkService: StoreNetworkServiceProtocol {
    private var networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

    private (set) var storeListUpdate = PassthroughSubject<StoresResponseModel, Never>()
    private var storeList = [StoreResponseModel]() {
        didSet {
            storeListUpdate.send(storeList)
        }
    }

    private (set) var chainListUpdate = PassthroughSubject<StoreChainsResponseModel, Never>()
    private var chainList = [StoreChainResponseModel]() {
        didSet {
            chainListUpdate.send(chainList)
        }
    }

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    func fetchChains() {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStoreChains,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let chainsResponse: StoreChainsResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(chainsResponse)
                    print("Store chains fetched successfully")

                    guard let self else { return }
                    self.chainList = chainsResponse.sorted { $0.id < $1.id }

                }

            } catch let error {
                print("Error fetching store chains: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    func fetchStores(page: Int) {
        let parameters = [
            "page": page
        ]

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStores,
                                                              additionalPath: "?" + parameters.queryString,
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let storesResponse: StoresResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(storesResponse)
                    print("Stores fetched successfully")

                    guard let self else { return }
                    self.storeList = storesResponse.sorted { $0.id < $1.id }
                }
            } catch let error {
                print("Error fetching stores: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }
}
