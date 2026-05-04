@testable import TravelBookBackend
import Foundation
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct TravelBookBackendTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("CellDTO uses client JSON keys")
    func cellDTOCodingKeys() throws {
        let dto = CellDTO(id: UUID(),
                          image: "image",
                          type: "food",
                          title: "title",
                          subtitle: "subtitle",
                          date: .now,
                          readingTime: 5,
                          description: "description",
                          images: [],
                          isPopular: true,
                          isHeadCell: false)

        let data = try JSONEncoder().encode(dto)
        let object = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["category"] as? String == "food")
        #expect(object["reading_time"] as? Int == 5)
        #expect(object["is_popular"] as? Bool == true)
        #expect(object["is_head_cell"] as? Bool == false)
    }

    @Test("UserDTO uses date_registered JSON key")
    func userDTOCodingKeys() throws {
        let dto = UserDTO(id: UUID(),
                          name: "name",
                          email: "email@test.com",
                          dateRegistered: .now)

        let data = try JSONEncoder().encode(dto)
        let object = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["date_registered"] != nil)
        #expect(object["dateRegistered"] == nil)
    }
}
