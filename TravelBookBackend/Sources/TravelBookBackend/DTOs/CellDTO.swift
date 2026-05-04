import Vapor

struct CellDTO: Content {
    let id: UUID?
    let title: String
    let subtitle: String
    let description: String
    let category: String
    let date: Date
    let readingTime: Int
    let image: String
    let images: [String]
    let isPopular: Bool
    let isHeadCell: Bool

    init(id: UUID?,
         image: String,
         type: String,
         title: String,
         subtitle: String,
         date: Date,
         readingTime: Int,
         description: String,
         images: [String],
         isPopular: Bool,
         isHeadCell: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.category = type
        self.date = date
        self.readingTime = readingTime
        self.image = image
        self.images = images
        self.isPopular = isPopular
        self.isHeadCell = isHeadCell
    }

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, description, category, date, image, images
        case readingTime = "reading_time"
        case isPopular = "is_popular"
        case isHeadCell = "is_head_cell"
    }
}
