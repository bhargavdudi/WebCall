// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum NetworkError: Error {
    case badRequest
    case decodingError
}

public class Webservice {
    
    public init() { }
    
    public func fetch<T: Codable>(url: URL, resultType: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void)  {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(.failure(.decodingError))
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            }
            catch let error {
                print(error)
                completion(.failure(NetworkError.decodingError))
            }
            
        }.resume()
        
    }
    
}

