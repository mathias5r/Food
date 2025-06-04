//
//  HttpClient.swift
//  Food
//
//  Created by Mathias da Rosa on 02/06/25.
//

import Foundation
import Alamofire

protocol HttpClientProtocol {
    func get(path: String, params: Encodable, completion: @escaping (Result<Data?, AFError>) -> Void) -> Void
}

final class HttpClient: HttpClientProtocol {
    static let shared = HttpClient()
    private init() {}

    private let baseURL = "http://localhost:3000/api/restaurants"

    func get(path: String, params: Encodable, completion: @escaping (Result<Data?, AFError>) -> Void) -> Void {
        AF.request(path, method: .get, parameters: params).response { response in
            completion(response.result)
        }
    }
}
