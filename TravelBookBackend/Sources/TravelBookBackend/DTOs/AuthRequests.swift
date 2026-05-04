import Vapor

struct CreateAccountRequest: Content {
    let email: String
    let name: String
    let password: String
}

struct SignInRequest: Content {
    let email: String
    let password: String
}
