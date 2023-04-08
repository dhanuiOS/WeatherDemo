//
//  WeatherAPIManager.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import Foundation
protocol WeatherAPIDelegate {
    func getWeatherResponse(for location: String, completionHandler: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

class WeatherAPIManager: WeatherAPIDelegate {
    private var networkManager: NetworkManagerDelegate
    
    init(networkManager: NetworkManagerDelegate = AlamofireNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getWeatherResponse(for location: String, completionHandler: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        networkManager.getWeatherDataFromServer(url: "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(Constants.API_KEY)&units=metric", completionHandler: completionHandler)
    }
   
    
}
