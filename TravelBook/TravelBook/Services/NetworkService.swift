//
//  NetworkHelper.swift
//  TravelBook
//
//  Created by ddorsat on 09.01.2026.
//

import Foundation

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol NetworkServiceProtocol: Sendable {
    func createAccount(name: String, email: String, password: String) async throws
    func signIn(email: String, password: String) async throws -> AuthTokenResponse
    func fetchFavorites() async throws -> [CellModel]
    func addFavorite(id: UUID) async throws
    func removeFavorite(id: UUID) async throws
    func fetchCells(page: Int, limit: Int, seed: String) async throws -> [CellModel]
    func fetchPopularCells() async throws -> [CellModel]
    func fetchCategories() async throws -> [CategoryModel]
    func fetchSearchResults(term: String) async throws -> [CellModel]
}

nonisolated final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession

    private let tokenPath = Constants.tokenPath
    private let tokenKey = Constants.tokenKey

    init(baseURL: String = Constants.address,
         session: URLSession = NetworkService.makeSession()) {
        self.baseURL = baseURL
        self.session = session
    }

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 300
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }

    func createAccount(name: String, email: String, password: String) async throws {
        let body = try JSONEncoder().encode(AuthSignUpBody(name: name, email: email, password: password))
        _ = try await request(endpoint: "/auth/createAccount", method: .post, body: body)
    }

    func signIn(email: String, password: String) async throws -> AuthTokenResponse {
        let body = try JSONEncoder().encode(AuthSignInBody(email: email, password: password))
        let data = try await request(endpoint: "/auth/signIn", method: .post, body: body)

        do {
            return try decoder().decode(AuthTokenResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func fetchFavorites() async throws -> [CellModel] {
        let data = try await request(endpoint: "/favorites", method: .get)

        do {
            return try decoder().decode([CellModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func addFavorite(id: UUID) async throws {
        _ = try await request(endpoint: "/favorites/\(id.uuidString)", method: .post)
    }

    func removeFavorite(id: UUID) async throws {
        _ = try await request(endpoint: "/favorites/\(id.uuidString)", method: .delete)
    }

    func fetchCells(page: Int, limit: Int, seed: String) async throws -> [CellModel] {
        let data = try await request(endpoint: "/cells?page=\(page)&limit=\(limit)&seed=\(seed)", method: .get)

        do {
            return try decoder().decode([CellModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func fetchPopularCells() async throws -> [CellModel] {
        let data = try await request(endpoint: "/popular", method: .get)

        do {
            return try decoder().decode([CellModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func fetchCategories() async throws -> [CategoryModel] {
        let data = try await request(endpoint: "/categories", method: .get)

        do {
            return try decoder().decode([CategoryModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    func fetchSearchResults(term: String) async throws -> [CellModel] {
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "search", value: term)]

        guard let query = components.percentEncodedQuery else {
            throw NetworkError.invalidURL
        }

        let data = try await request(endpoint: "/search?\(query)", method: .get)

        do {
            return try decoder().decode([CellModel].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    private func request(endpoint: String,
                         method: HTTPMethod,
                         body: Data? = nil,
                         attempt: Int = 0) async throws -> Data {
        do {
            return try await performRequest(endpoint: endpoint, method: method, body: body)
        } catch let urlError as URLError where Self.isRetryable(urlError) && attempt < 2 {
            try await Task.sleep(for: Self.retryDelay(for: attempt))
            return try await request(endpoint: endpoint, method: method, body: body, attempt: attempt + 1)
        } catch let urlError as URLError {
            throw NetworkError(urlError: urlError)
        }
    }

    private static func isRetryable(_ error: URLError) -> Bool {
        switch error.code {
            case .timedOut,
                 .networkConnectionLost,
                 .cannotConnectToHost,
                 .cannotFindHost,
                 .dnsLookupFailed,
                 .notConnectedToInternet:
                return true
            default:
                return false
        }
    }

    private static func retryDelay(for attempt: Int) -> Duration {
        .seconds(Double(attempt) + 0.5)
    }

    private func performRequest(endpoint: String,
                                method: HTTPMethod,
                                body: Data? = nil) async throws -> Data {
        guard let baseURL = URL(string: baseURL),
              let url = URL(string: endpoint, relativeTo: baseURL)?.absoluteURL else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body

        if let tokenData = KeychainHelper.standard.read(path: tokenPath, key: tokenKey),
           let token = String(data: tokenData, encoding: .utf8) {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
            case 200...299:
                return data
            case 400:
                throw NetworkError.apiError(message: "Status: \(httpResponse.statusCode)")
            case 401:
                throw NetworkError.incorrentSignInCredentials
            case 409:
                throw NetworkError.userAlreadyExists
            default:
                throw NetworkError.apiError(message: "Status: \(httpResponse.statusCode)")
        }
    }

    private func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

struct AuthTokenResponse: Decodable {
    let token: String
    let user: UserModel
}

private struct AuthSignUpBody: Encodable {
    let name: String
    let email: String
    let password: String
}

private struct AuthSignInBody: Encodable {
    let email: String
    let password: String
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(message: String)
    case decodingError
    case userAlreadyExists
    case incorrentSignInCredentials
    case timedOut
    case noConnection
    case cannotReachServer

    init(urlError: URLError) {
        switch urlError.code {
            case .timedOut:
                self = .timedOut
            case .notConnectedToInternet, .networkConnectionLost:
                self = .noConnection
            case .cannotConnectToHost, .cannotFindHost, .dnsLookupFailed:
                self = .cannotReachServer
            default:
                self = .invalidResponse
        }
    }

    var errorDescription: String? {
        switch self {
            case .invalidURL: return "Некорректный URL"
            case .invalidResponse: return "Некорректный ответ от сервера"
            case .apiError(let msg): return "Ошибка сервера: \(msg)"
            case .decodingError: return "Ошибка декодирования"
            case .userAlreadyExists: return "Пользователь уже зарегистрирован"
            case .incorrentSignInCredentials: return "Неправильный логин или пароль"
            case .timedOut: return "Сервер просыпается дольше обычного. Попробуйте ещё раз через минуту"
            case .noConnection: return "Нет подключения к интернету"
            case .cannotReachServer: return "Не удалось связаться с сервером. Попробуйте позже"
        }
    }
}
