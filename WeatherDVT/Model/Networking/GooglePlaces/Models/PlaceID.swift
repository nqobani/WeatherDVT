//
//  PlaceID.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct PlaceID: Codable {
    let place_id: String?
    
    enum CodingKeys: String, CodingKey {
        case place_id
    }
}
