import Combine
import Foundation

protocol StoreNetworkServiceProtocol {
    var storeListUpdate: PassthroughSubject<StoresResponseModel, Never> { get }
    var chainListUpdate: PassthroughSubject<StoreChainsResponseModel, Never> { get }

    func fetchStores(page: Int)
    func fetchChains()
}

actor StoreNetworkService: StoreNetworkServiceProtocol {
    private var networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let storeListUpdate = PassthroughSubject<StoresResponseModel, Never>()
    private var storeList = [StoreResponseModel]() {
        didSet {
            storeListUpdate.send(storeList)
        }
    }

    nonisolated let chainListUpdate = PassthroughSubject<StoreChainsResponseModel, Never>()
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

    nonisolated func fetchChains() {
        Task { await getChains() }
    }

    private func getChains() async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStoreChains,
                                                              additionalPath: nil,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let chainsResponse: StoreChainsResponseModel = try await networkClient.request(for: urlRequest)
            print("Store chains fetched successfully")
//            print(chainsResponse)

            self.chainList = chainsResponse.sorted { $0.id < $1.id }
        } catch let error {
            print("Error fetching store chains: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func fetchStores(page: Int) {
        Task { await getStores(page: page) }
    }

    private func getStores(page: Int) async {
        let parameters = [
            "page": page
        ]

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStores,
                                                              additionalPath: "?" + parameters.queryString,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let storesResponse: StoresResponseModel = try await networkClient.request(for: urlRequest)
            print("Stores fetched successfully")

            self.storeList = storesResponse.sorted { $0.id < $1.id }
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
