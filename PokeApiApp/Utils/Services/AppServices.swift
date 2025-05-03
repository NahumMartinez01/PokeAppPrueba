//
//  AppServices.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//

import Foundation

protocol AppServicesProtocol {
    func fetchRequest<T: Decodable>(
        url: String,
        method: String,
        headers: [String: String]?,
        body: Data?,
        responseType: T.Type
    ) async throws -> T
}

final class AppServices {
    static let shared = AppServices()
    private init() {}
}

//MARK: CONFIGURACIÓN DE NUESTRO URLSESSION
extension AppServices: AppServicesProtocol {
    
    func fetchRequest<T: Decodable>(
        url: String,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: url) else {
            print("Invalid URL: \(url)")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.timeoutInterval = 60.0
        
        // PARA TRABAJAR CONEXIONES LENTAS SE SETEA UNOS TIMEOUT
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 300.0
        let session = URLSession(configuration: sessionConfig)
        
        let (data, response) = try await session.data(for: request)
        
        #if DEBUG
        AppServicesUtils.printRequest(
            requestUrl: url.absoluteString,
            method: method,
            parameters: nil,
            customHeaders: headers ?? [:],
            responseData: data
        )
        #endif
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
