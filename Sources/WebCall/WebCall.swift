// The Swift Programming Language
// https://docs.swift.org/swift-book




import Foundation

public enum NetworkError: Error {
    case badRequest
    case decodingError
    case invalidUrl
    case invalidResponse
    case internalServerError
}

public class Webservice {
    
    public init() { }
    
   public func getApiData<T:Decodable>(urlString: String, resultType: T.Type, completion:@escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
               
       // send Request
        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            if error != nil {
                completion(.failure(NetworkError.invalidUrl))
            }
            if(error == nil && responseData != nil && responseData?.count != 0) {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    completion(.success(result))
                }
                catch let error {
                    print(error)
                    completion(.failure(NetworkError.decodingError))
                }
            } else if (responseData != nil && responseData?.count != 0) {
                completion(.failure(NetworkError.internalServerError))
            }
            else if (error as? URLError)?.code == .timedOut {
                completion(.failure(NetworkError.internalServerError))
            }
            
        }.resume()
    }
    
}

