import Vapor

struct UserDTO: Content {
    let id: UUID?
    let name: String
    let email: String
    let dateRegistered: Date

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case dateRegistered = "date_registered"
    }
}
