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
                print(response.response?.statusCode ?? 200)
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
                print(data)
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
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Ha ocurrido un error", message: "Ha ocurrido un problema a la hora de realizar la busqueda", preferredStyle: .alert)
        let action = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(action)
    }
    
}
