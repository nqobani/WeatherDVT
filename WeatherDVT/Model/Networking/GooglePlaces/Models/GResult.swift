//
//  GResult.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
struct GResult: Codable {
    let addressComponents: [AddressComponent]
    let adrAddress, formattedAddress: String
    let geometry: Geometry
    let icon: String
    let name: String
    let placeID, reference: String
    let types: [String]
    let url: String
    let utcOffset: Int
    let vicinity: String
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case adrAddress = "adr_address"
        case formattedAddress = "formatted_address"
        case geometry, icon
        case name
        case placeID = "place_id"
        case reference, types, url
        case utcOffset = "utc_offset"
        case vicinity
    }
}
