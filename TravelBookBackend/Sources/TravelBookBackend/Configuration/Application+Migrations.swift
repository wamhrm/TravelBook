import Vapor

extension Application {
    func configureMigrations() {
        self.migrations.add(CreateCategories())
        self.migrations.add(CreateCells())
        self.migrations.add(CreateUsers())
        self.migrations.add(CreateTokens())
        self.migrations.add(CreateUserFavorites())
    }
}
