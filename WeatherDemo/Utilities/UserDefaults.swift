//
//  UserDefaults.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import Foundation

@propertyWrapper
struct Storage {
    private let key: String
    private let defaultValue: String
    
    init(key: String, defaultValue: String) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: String {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.string(forKey: key) ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// The UserDefaults wrapper
struct AppData {
    @Storage(key: "last_search_location", defaultValue: "")
    static var last_search_location: String
}
struct currentLocation {
    @Storage(key: "currentLoc", defaultValue: "")
    static var current_location: String
}
