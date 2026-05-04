//
//  Networ.swift
//  TravelBook
//
//  Created by ddorsat on 09.01.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(message: String)
    case decodingError
    case userAlreadyExists
    case incorrentsigInCredentials
    case badRequest(message: String)

    var errorDescription: String? {
        switch self {
            case .invalidURL: return "Некорректный URL"
            case .invalidResponse: return "Некорректный ответ от сервера"
            case .apiError(let msg): return "Ошибка сервера: \(msg)"
            case .decodingError: return "Decoding Error"
            case .userAlreadyExists: return "Пользователь уже зарегистрирован"
            case .incorrentsigInCredentials: return "Неправильный логин или пароль"
            case .badRequest(let msg): return msg
        }
    }
}

struct NetworkHelper {
    private static let tokenPath = Constants.tokenPath
    private static let tokenKey = Constants.tokenKey

    static func request(url: String, method: String) async throws -> Data {
        return try await request(url: url, method: method, body: nil as String?)
    }

    static func request<T: Encodable>(url: String, method: String, body: T?) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let tokenData = KeychainHelper.standard.read(path: tokenPath, key: tokenKey),
           let token = String(data: tokenData, encoding: .utf8) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body { request.httpBody = try JSONEncoder().encode(body) }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
            case 200...299:
                return data
            case 400:
                throw NetworkError.apiError(message: "Status: \(httpResponse.statusCode)")
            case 401:
                throw NetworkError.incorrentsigInCredentials
            case 409:
                throw NetworkError.userAlreadyExists
            default:
                throw NetworkError.apiError(message: "Status: \(httpResponse.statusCode)")
        }
    }

    static func fetch<T: Decodable>(url: String) async throws -> T {
        let data = try await request(url: url, method: "GET")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
