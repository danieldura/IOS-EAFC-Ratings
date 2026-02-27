//
//  NetworkError.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(statusCode: Int)
    case networkError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos"
        case .decodingError(let error):
            return "Error al procesar datos: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "Error del servidor (código \(statusCode))"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .unknown:
            return "Error desconocido"
        }
    }
}
