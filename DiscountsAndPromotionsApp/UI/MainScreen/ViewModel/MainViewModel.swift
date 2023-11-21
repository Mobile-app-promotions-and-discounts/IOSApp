import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {

    private (set) var categoriesList = [Category]()

    func viewDidLoad() {
        self.categoriesList = MockDataService.shared.getCategoriesList()
    }

    func getNumberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return categoriesList.count
        default:
            return 0
        }
    }

    func getTitleForItemAt(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return categoriesList[indexPath.row].name
        default:
            return ""
        }
    }
}
