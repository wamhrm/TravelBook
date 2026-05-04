import Vapor

struct ImageUpload: Content {
    var file: File
}

struct BulkUpload: Content {
    var files: [File]
}
