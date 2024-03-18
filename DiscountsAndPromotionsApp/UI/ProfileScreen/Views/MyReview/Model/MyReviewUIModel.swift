import Foundation

struct MyReviewUIModel {
    let id: Int
    let name: String
    let comment: String
    let rating: Int
    let imageURLString:String?

    static let examples: [MyReviewUIModel] = [
        MyReviewUIModel(id: 0,
                        name: "Томаты сливовидные",
                        comment: "Отличные томаты, свежие, сочные",
                        rating: 5,
                        imageURLString: "https://static.tildacdn.com/tild3263-6265-4332-a236-653966613865/sochnaya-myakot-toma.jpg"),
        MyReviewUIModel(id: 1,
                        name: "Бананы",
                        comment: "Бананы вкусные, но немного переспелые, поэтому снимаю 1 звезду.",
                        rating: 4,
                        imageURLString: "https://hips.hearstapps.com/hmg-prod/images/bananas-royalty-free-image-1702061943.jpg"),
        MyReviewUIModel(id: 2,
                        name: "Салат айсберг",
                        comment: "Свежий салат. Остался очень доволен покупкой и ценой.",
                        rating: 5,
                        imageURLString: "")
    ]

}
