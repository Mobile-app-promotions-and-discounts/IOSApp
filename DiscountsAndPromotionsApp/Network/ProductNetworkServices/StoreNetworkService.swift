import Combine
import Foundation

protocol StoreNetworkServiceProtocol {
    var storeListUpdate: PassthroughSubject<StoresResponseModel, Never> { get }
    var chainListUpdate: CurrentValueSubject<StoreChainsResponseModel, Never> { get }

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

    nonisolated let chainListUpdate = CurrentValueSubject<StoreChainsResponseModel, Never>([])

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    nonisolated func fetchChains() {
        Task { await getChains() }
    }

    private func getChains() async {
        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStoreChains,
                                                              additionalPath: nil,
                                                              headers: headers,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let chainsResponse: StoreChainsResponseModel = try await networkClient.request(for: urlRequest)
            print("Store chains fetched successfully")
            print(chainsResponse)

            let chainList = chainsResponse.sorted { $0.id < $1.id }
            chainListUpdate.send(chainList)
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
        let additionalPath = "?" + parameters.queryString
        let headers = NetworkBaseConfiguration.accessTokenHeader()

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getStores,
                                                              additionalPath: additionalPath,
                                                              headers: headers,
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
