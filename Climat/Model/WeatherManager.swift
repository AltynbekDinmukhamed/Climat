//
//  WeatherManeger.swift
//  Climat
//
//  Created by Димаш Алтынбек on 27.02.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ wheatherManager: WeatherManager, wheather: WeatherModel)
    func didFailError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a554baec2b6235a9f5490062dd519736&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlStrnig = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlStrnig)
        print(urlStrnig)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a url
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, wheather: weather)
                    }
                }
                
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weahterData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weahterData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            print(weather.conditionName)
            print(weather.temperatureString)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchWeahter(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: urlString)
    }
    
    
}
