import Combine
import UIKit

protocol ProfileViewModelProtocol: AnyObject {
    var profile: CurrentValueSubject <ProfileUIModel, Never> { get }

    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisapear()

    func getTableViewCount() -> Int
    func getTableViewConfigure(_ index: Int) -> ProfilePropertyUIModel
    func exitAccount()
}
