import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ContentController())
    try app.register(collection: UploadController())
    try app.register(collection: AdminController())
    try app.register(collection: AuthController())
    try app.register(collection: FavoritesController())
}
