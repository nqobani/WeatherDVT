//
//  CurrentWeatherResponse.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct CurrentWeatherResponse: Codable {
    let weather: [WeatherItem]
    let main: Main
    let date:String?
    
    init?(){
        return nil
    }
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case date = "dt_txt"
    }
}
