//
//  NetworkService.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    func getProducts(query: [String : String?], completed: @escaping (Result<BaseProducts,Error>) -> Void) {
        AF.request(Endpoints.Search, method: .get, parameters: query).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(BaseProducts.self, from: data)
                    completed(.success(result))
                } catch {
                    completed(.failure(error))
                }
            case .failure(let error):
                print(error)
                print(response.response?.statusCode ?? 200)
            }
        }
    }
    
}
