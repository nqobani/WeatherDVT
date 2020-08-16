//
//  Geometry.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct Geometry: Codable {
    let location: Location
  
    enum CodingKeys: String, CodingKey {
        case location
    }
}
