import Vapor
import Foundation
import SotoS3

struct StorageController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.post("api", "upload", use: uploadImages)
    }
    
    private func uploadImages(_ req: Request) async throws -> [String] {
        guard let s3 = req.application.storage[S3Key.self] else {
            throw Abort(.internalServerError, reason: "S3 not configured")
        }

        let input = try req.content.decode(BulkUpload.self)
        var uploadedURLs: [String] = []
        guard let bucketName = Environment.get("S3_BUCKET") ?? Environment.get("S3_BUCKET_NAME") else {
            throw Abort(.internalServerError, reason: "S3 bucket not configured")
        }

        let endpoint = Environment.get("S3_ENDPOINT") ?? "https://s3.twcstorage.ru"
        let publicBaseURL = Environment.get("S3_PUBLIC_URL") ?? "\(endpoint)/\(bucketName)"
        let normalizedPublicBaseURL = publicBaseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        for file in input.files {
            let filename = "\(UUID().uuidString).\(file.extension ?? "jpg")"

            let putRequest = S3.PutObjectRequest(acl: .publicRead,
                                                 body: .byteBuffer(file.data),
                                                 bucket: bucketName,
                                                 contentType: file.contentType?.serialize(),
                                                 key: filename)

            _ = try await s3.putObject(putRequest)

            let publicURL = "\(normalizedPublicBaseURL)/\(filename)"
            uploadedURLs.append(publicURL)
        }

        return uploadedURLs
    }
}
