//
//  HttpClient.swift
//  Food
//
//  Created by Mathias da Rosa on 02/06/25.
//

import Alamofire
import Foundation

protocol HttpClientProtocol {
    func get(
        path: String,
        params: Encodable,
        completion: @escaping (Result<Data?, AFError>) -> Void
    )
    func get(path: String, completion: @escaping (Result<Data?, AFError>) -> Void)
}

final class HttpClient: HttpClientProtocol {
    static let shared = HttpClient()
    private init() {}

    private let baseURL = "http://localhost:3000/api"

    func get(
        path: String,
        params: Encodable,
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        AF.request(baseURL + path, method: .get, parameters: params).response { response in
            completion(response.result)
        }
    }

    func get(path: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(baseURL + path, method: .get).response { response in
            completion(response.result)
        }
    }
}
