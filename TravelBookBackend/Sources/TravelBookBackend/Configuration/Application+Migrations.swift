import Vapor

extension Application {
    func configureMigrations() {
        self.migrations.add(CreateCategory())
        self.migrations.add(CreateCell())
        self.migrations.add(CreateUser())
        self.migrations.add(CreateToken())
        self.migrations.add(CreateUserFavorite())
    }
}
