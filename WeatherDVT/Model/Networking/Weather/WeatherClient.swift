//
//  WeatherClient.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/14.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct WeatherClient {
    let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=10e02294d2626d5619b5a315d362e0c7&units=metric"
    let forecastWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=10e02294d2626d5619b5a315d362e0c7&units=metric"
    
    var currentWeatherdelegate: CurrentWeatherDelegate?
    var weatherForecastDelegate: WeatherForecastDelegate?
    
    func getCurrentWeather(lat: Double, lon: Double) {
        let urlString = "\(currentWeatherURL)&lat=\(lat)&lon=\(lon)"
        
        performTask(urlString, decodingType: CurrentWeatherResponse.self, completion: {result in
            switch result{
            case .success(let currentWeatherResponse):
                self.currentWeatherdelegate?.onCurrentWeatherSuccess(result: currentWeatherResponse)
            case .failure(let err):
                self.currentWeatherdelegate?.onCurrentWeatherFailure(err: err)
            }
        })
    }
    
    func getWeatherForecast(lat: Double, lon: Double)  {
        let urlString = "\(forecastWeatherURL)&lat=\(lat)&lon=\(lon)"
        
        performTask(urlString, decodingType: ForecastResponse.self, completion: {result in
            switch result{
            case .success(let weatherForecast):
                self.weatherForecastDelegate?.onWeatherForecastSuccess(result: weatherForecast)
            case .failure(let err):
                self.weatherForecastDelegate?.onWeatherForecastFailure(err: err)
            }
        })
    }
    
    func performTask<T: Decodable>(_ urlString: String, decodingType: T.Type,completion: @escaping (Result<T, Error>)->()) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, err: Error?) in
                if let err = err {
                    completion(.failure(err))
                    return
                }
                
                do{
                    let weatherResponse = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(weatherResponse))
                } catch let jsonError{
                    completion(.failure(jsonError))
                }
            }
            task.resume()
        }
    }
    
    
}
