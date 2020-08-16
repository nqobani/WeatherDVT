//
//  GooglePlaceID_Delegate.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
protocol GoogleSearchDelegate {
    func onPlaceSearchSuccess(result: SearchResponse)
    func onPlaceSearchFailure(error: Error)
}
