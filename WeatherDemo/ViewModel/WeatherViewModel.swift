//
//  WeatherViewModel.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import Foundation
class WeatherViewModel: ObservableObject {
    var weatherAPIManager: WeatherAPIDelegate
    
    init(userRepository: WeatherAPIDelegate = WeatherAPIManager()) {
        self.weatherAPIManager = userRepository
    }
    
    @Published var weatherData: WeatherData?
    
}

//logic for JsonPlaceHolder Data
extension WeatherViewModel {
    func getWeatherReport(location: String) {
        weatherAPIManager.getWeatherResponse(for: location) { result in
            switch result {
                case .success(let success):
                    self.getSpecificWeatherReport(data: success)
                case .failure(let failure):
                    self.weatherData = nil
                    print(failure)
            }
        }
    }
    
    private func getSpecificWeatherReport(data: WeatherResponse) {
        weatherData = WeatherData(temp: data.main.temp, tempMin: data.main.tempMin, tempMax: data.main.tempMax, humidity: data.main.humidity, icon: data.weather[0].icon, name: data.name, description: data.weather[0].description, country: data.sys.country)
        print("weeather Data is \(weatherData)")
    }
}
