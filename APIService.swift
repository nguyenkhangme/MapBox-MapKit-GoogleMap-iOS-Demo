//
//  APIService.swift
//  mapApp
//
//  Created by Vinova on 4/23/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

class APIService {
    
    enum APIError: Error {

        case missingData

    }

    enum Result<T> {

        case success(T)
        case failure(Error)

    }
    
    static let shared = APIService()

    let defaultSession = URLSession(configuration: .default)

    typealias SerializationFunction<T> = (Data?, URLResponse?, Error?) -> Result<T>
    
    @discardableResult
    private func request<T>(_ url: URL, serializationFunction: @escaping SerializationFunction<T>,
                            completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            let result: Result<T> = serializationFunction(data, response, error)
            DispatchQueue.main.async {
                completion(result)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        return request(url, serializationFunction: serializeJSON, completion: completion)
    }
    
    private func serializeJSON<T: Decodable>(with data: Data?, response: URLResponse?, error: Error?) -> Result<T> {
        if let error = error { return .failure(error) }
        guard let data = data else { return .failure(APIError.missingData) }
        do {
            let serializedValue = try JSONDecoder().decode(T.self, from: data)
            return .success(serializedValue)
        } catch let error {
            return .failure(error)
        }
    }
}
