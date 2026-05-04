import Vapor

public func configure(_ app: Application) async throws {
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
    app.routes.defaultMaxBodySize = "50mb"

    try app.configureDatabase()
    try app.configureS3()

    app.configureMigrations()

    try routes(app)
}
