import Vapor

struct AdminController: RouteCollection {
    private let databaseSeeder = DatabaseSeeder()

    func boot(routes: any RoutesBuilder) throws {
        routes.get("clear", use: clearDatabase)
        routes.get("upload", use: seedDatabase)
    }

    private func clearDatabase(_ req: Request) async throws -> String {
        try await databaseSeeder.clear(on: req.db)
        return "База данных очищена"
    }

    private func seedDatabase(_ req: Request) async throws -> String {
        try await databaseSeeder.seed(on: req.db)
        return "База данных обновлена!"
    }
}
