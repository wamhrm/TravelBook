import Vapor
import SotoS3

extension Application {
    func configureS3() throws {
        guard let keyId = Environment.get("S3_ACCESS_KEY"),
              let secret = Environment.get("S3_SECRET_KEY") else {
            throw Abort(.internalServerError, reason: "S3 not configured")
        }

        let endpoint = Environment.get("S3_ENDPOINT") ?? "https://s3.twcstorage.ru"
        let region = Environment.get("S3_REGION") ?? "ru-1"

        let awsClient = AWSClient(credentialProvider: .static(accessKeyId: keyId, secretAccessKey: secret),
                                  httpClientProvider: .createNew)

        let s3 = S3(client: awsClient, region: Region(rawValue: region), endpoint: endpoint)

        self.storage[S3Key.self] = s3
        self.lifecycle.use(AWSClientLifecycleHandler(client: awsClient))
    }
}

struct S3Key: StorageKey {
    typealias Value = S3
}

fileprivate struct AWSClientLifecycleHandler: LifecycleHandler {
    private let client: AWSClient

    init(client: AWSClient) {
        self.client = client
    }

    func shutdown(_ application: Application) {
        try? client.syncShutdown()
    }
}
