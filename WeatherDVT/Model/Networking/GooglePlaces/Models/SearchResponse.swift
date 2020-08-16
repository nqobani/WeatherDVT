//
//  SearchResponse.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct SearchResponse: Codable {
    let candidates: [PlaceID]
    
    enum CodingKeys: String, CodingKey {
        case candidates
    }
}
