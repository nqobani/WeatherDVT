//
//  PlaseDetailsResponse.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct PlaseDetailsResponse: Codable{
    let result: GResult
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case status
    }
}
