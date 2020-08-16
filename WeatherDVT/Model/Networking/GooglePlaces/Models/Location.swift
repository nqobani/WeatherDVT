//
//  Location.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct Location: Codable {
    let lat, lng: Double
    
    enum CodingKeys: String, CodingKey {
        case lat, lng
    }
}
