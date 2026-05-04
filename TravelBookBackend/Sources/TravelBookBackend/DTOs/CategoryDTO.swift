import Vapor

struct CategoryDTO: Content {
    let id: UUID?
    let title: String
    let type: String
    let image: String
    let cells: [CellDTO]
}
