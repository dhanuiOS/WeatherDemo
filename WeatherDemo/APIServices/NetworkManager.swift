//
//  NetworkManager.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import Foundation
import Alamofire

protocol NetworkManagerDelegate {
    func getWeatherDataFromServer<T: Decodable>(url: String, completionHandler: @escaping (Result<T, NetworkError>) -> ())
}

class AlamofireNetworkManager: NetworkManagerDelegate {
    
    func getWeatherDataFromServer<T: Decodable>(url: String, completionHandler: @escaping (Result<T, NetworkError>) -> ()) {
        AF.request(url, method: .get).response { response in
            DispatchQueue.main.async {
                guard let data = response.data,
                      let list = try?
                        JSONDecoder()
                    .decode(T.self, from: data)
                else {
                    print("failed to Decoder")
                    completionHandler(.failure(.noDataFound))
                    return
                }
                completionHandler(.success(list))
            }
        }
    }
    
}


enum NetworkError: Error {
    case noDataFound
    case inValidUrl
}
