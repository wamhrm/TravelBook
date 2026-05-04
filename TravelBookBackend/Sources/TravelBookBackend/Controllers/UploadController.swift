import Vapor

struct UploadController: RouteCollection {
    private let storageController = StorageController()

    func boot(routes: any RoutesBuilder) throws {
        routes.post("api", "upload", use: storageController.uploadImages)
    }
}
