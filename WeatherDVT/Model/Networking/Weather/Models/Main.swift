//
//  Main.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct Main: Codable {
    let temp: Double
    let pressure: Double
    let temp_min: Double
    let temp_max: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case temp_min
        case temp_max
    }
}
