import Foundation

protocol MainViewModelProtocol {
    var categoriesList: [Category] { get }

    func viewDidLoad()
    func getNumberOfItemsInSection(section: Int) -> Int
    func getTitleForItemAt(indexPath: IndexPath) -> String
}
