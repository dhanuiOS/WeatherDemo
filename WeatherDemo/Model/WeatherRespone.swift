//
//  WeatherRespone.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import Foundation
// MARK: - WeatherData
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp) ?? 0.0
        feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike) ?? 0.0
        tempMin = try values.decodeIfPresent(Double.self, forKey: .tempMin) ?? 0.0
        tempMax = try values.decodeIfPresent(Double.self, forKey: .tempMax) ?? 0.0
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure) ?? 0
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
        seaLevel = try values.decodeIfPresent(Int.self, forKey: .seaLevel) ?? 0
        grndLevel = try values.decodeIfPresent(Int.self, forKey: .grndLevel) ?? 0
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        type = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise) ?? 0
        sunset = try values.decodeIfPresent(Int.self, forKey: .sunset) ?? 0

        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        main = try values.decodeIfPresent(String.self, forKey: .main) ?? ""
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
        icon = try values.decodeIfPresent(String.self, forKey: .icon) ?? ""
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed) ?? 0.0
        deg = try values.decodeIfPresent(Int.self, forKey: .deg) ?? 0
        gust = try values.decodeIfPresent(Double.self, forKey: .gust) ?? 0.0
    }
}

struct WeatherData {
    let temp, tempMin, tempMax: Double
    let humidity: Int
    let icon, name, description, country: String
}
