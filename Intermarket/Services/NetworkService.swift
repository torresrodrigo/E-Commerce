//
//  NetworkService.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 23/08/2021.
//

import Foundation
import UIKit
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    func getProducts(query: String, completed: @escaping (Result<BaseProducts,Error>) -> Void) {
        let finalUrl = String(describing: Endpoints.Search+query)
        AF.request(finalUrl).responseData { response in
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
                print(response.response?.statusCode ?? 0)
                completed(.failure(error))
            }
        }
    }
    
    func getDetailsProducts(query: String, completed: @escaping (Result<DetailProduct,Error>) -> Void) {
        let finalUrl = String(describing: Endpoints.DetailsProducts+query)
        AF.request(finalUrl, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                do {
                    let result = try decoder.decode(DetailProduct.self, from: data)
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
