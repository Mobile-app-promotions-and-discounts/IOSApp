import Combine
import Foundation

protocol EditProfileViewModelProtocol: AnyObject {

    var profile: CurrentValueSubject<ProfileUIModel,Never> { get }

    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisapear()

    func changeTextField(_ text: String?, tag: Int)
    func changeGender(_ gender: GenderModel)

}
