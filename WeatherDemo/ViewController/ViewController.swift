//
//  ViewController.swift
//  WeatherDemo
//
//  Created by PINNINTI DHANANJAYARAO on 08/04/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate
 {
    private var viewModel: WeatherViewModel = WeatherViewModel()

    @IBOutlet weak var locationSearchField: UITextField!
    var locationManager:CLLocationManager!
var currentLoc = ""
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var wetherImage: UIImageView!
  
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDetailsStackView: UIStackView!
    var currentlocation : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherForLastSearchLocation()
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.startUpdatingLocation()
            }
        }
          
    }
    
    func getWeatherForLastSearchLocation() {
        if AppData.last_search_location != "" {
            getweatherData(for: AppData.last_search_location)
        }else{
            
            getweatherData(for:  currentLocation.current_location)

        }
    }


}
//MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation

    print("user latitude = \(userLocation.coordinate.latitude)")
    print("user longitude = \(userLocation.coordinate.longitude)")

    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
        if (error != nil){
            print("error in reverseGeocode")
        }
        let placemark = placemarks! as [CLPlacemark]
        if placemark.count>0{
            let placemark = placemarks![0]
            print(placemark.locality!)
            print(placemark.administrativeArea!)
            print(placemark.country!)
            currentLocation.current_location = placemark.country!
        }
    }

}
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getweatherData(for: textField.text ?? "")
        return true
    }
    
}

extension ViewController {
    func getweatherData(for location: String) {
        viewModel.getWeatherReport(location: location)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateUIWithWeatherData()
            AppData.last_search_location = location
           
        }
    }
}

extension ViewController {
    
    func updateUIWithWeatherData() {
        if viewModel.weatherData != nil {
            weatherDetailsStackView.isHidden = false
            locationLabel.text = "\(viewModel.weatherData?.name ?? ""), \(viewModel.weatherData?.country ?? "")"
            weatherDiscriptionLabel.text = viewModel.weatherData?.description
            temperatureLabel.text = "\(String(format:"%.f", viewModel.weatherData?.temp ?? 0.0))°c"
            minTemperatureLabel.text = "\(String(format:"%.f", viewModel.weatherData?.tempMin ?? 0.0))°c"
            maxTemperatureLabel.text = "\(String(format:"%.f", viewModel.weatherData?.tempMax ?? 0.0))°c"
            humidityLabel.text = "\(viewModel.weatherData?.humidity ?? 0)%"
            if let object = viewModel.weatherData?.icon {
                let second = "\(Constants.WEATHER_ICON_URL)\(object)\(".png")"
                self.wetherImage.imageFromUrl(urlString: second)
            }else{
         }
        } else {
            self.openAlert(title: "Alert",
                           message: "location not found",
                           alertStyle: .alert,
                           actionTitles: ["Ok"],
                           actionStyles: [.default],
                           actions: nil)
        }
    }
}
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
