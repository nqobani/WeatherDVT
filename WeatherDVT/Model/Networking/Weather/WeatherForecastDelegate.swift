//
//  WeatherForecastDelegate.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
protocol WeatherForecastDelegate {
    func onWeatherForecastSuccess(result: ForecastResponse)
    func onWeatherForecastFailure(err: Error)
}
