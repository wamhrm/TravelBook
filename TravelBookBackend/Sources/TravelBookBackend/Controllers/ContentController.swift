import Vapor
import Fluent
import FluentSQL

struct ContentController: RouteCollection {
    private let databaseSeeder = DatabaseSeeder()

    func boot(routes: any RoutesBuilder) throws {
        routes.get("cells", use: getCells)
        routes.get("popular", use: getPopularCells)
        routes.get("categories", use: getCategories)
        routes.get("users", use: getUsers)
        routes.get("search", use: searchCells)
        
        routes.get("clear", use: clearDatabase)
        routes.get("upload", use: uploadDatabase)
    }

    private func getCells(_ req: Request) async throws -> [CellDTO] {
        let page = req.query[Int.self, at: "page"] ?? 1
        let limit = req.query[Int.self, at: "limit"] ?? 6
        let rawSeed = req.query[String.self, at: "seed"] ?? ""
        let safeSeed = rawSeed.filter { $0.isLetter || $0.isNumber || $0 == "-" }
        let offset = (page - 1) * limit

        let cells = try await Cell.query(on: req.db)
            .with(\.$category)
            .sort(.sql(unsafeRaw: "md5(id::text || '\(safeSeed)')"))
            .range(offset..<(offset + limit))
            .all()

        return cells.map { $0.toDTO() }
    }

    private func getPopularCells(_ req: Request) async throws -> [CellDTO] {
        let popularCells = try await Cell.query(on: req.db)
            .with(\.$category)
            .filter(\.$isPopular == true)
            .all()

        return popularCells.map { $0.toDTO() }
    }

    private func getCategories(_ req: Request) async throws -> [CategoryDTO] {
        let categories = try await Category.query(on: req.db)
            .with(\.$cells) { $0.with(\.$category) }
            .all()

        return categories.map { $0.toDTO() }
    }

    private func getUsers(_ req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()

        return users.map { $0.toDTO() }
    }

    private func searchCells(_ req: Request) async throws -> [CellDTO] {
        let searchTerm = req.query[String.self, at: "search"]
        let categoryTerm = req.query[String.self, at: "category"]
        let query = Cell.query(on: req.db).with(\.$category)

        if let search = searchTerm, !search.isEmpty {
            query.join(Category.self, on: \Cell.$category.$id == \Category.$id)
            query.group(.or) { group in
                group.filter(\.$title, .custom("ILIKE"), "%\(search)%")
                group.filter(\.$subtitle, .custom("ILIKE"), "%\(search)%")
                group.filter(Category.self, \Category.$title, .custom("ILIKE"), "%\(search)%")
                group.filter(Category.self, \Category.$type, .custom("ILIKE"), "%\(search)%")
            }
        } else if let category = categoryTerm, !category.isEmpty {
            query.join(Category.self, on: \Cell.$category.$id == \Category.$id)
                .filter(Category.self, \.$type == category)
        }

        let cells = try await query.all()

        return cells.map { $0.toDTO() }
    }

    private func clearDatabase(_ req: Request) async throws -> String {
        try await databaseSeeder.clear(on: req.db)
        return "База данных очищена"
    }

    private func uploadDatabase(_ req: Request) async throws -> String {
        try await databaseSeeder.seed(on: req.db)
        return "База данных обновлена!"
    }
}
