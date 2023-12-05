import UIKit

import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var cancellables = Set<AnyCancellable>()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().barTintColor = UIColor.cherryWhite

        AuthService().getToken(for: NetworkBaseConfiguration.testUser)

//        let body = [
//            "username": NetworkBaseConfiguration.testUser.username,
//            "password": NetworkBaseConfiguration.testUser.password
//        ]
//
//        let publisher: AnyPublisher<TokenResponseModel, AppError> = NetworkService.shared.request(endpoint: Endpoint.getToken, headers: nil, parameters: body)
//
//        publisher.sink { completion in
//            switch completion {
//            case .finished:
//                print("Request completed successfully")
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        } receiveValue: { value in
//            print("Received value: \(value)")
//        }
//        .store(in: &cancellables)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
