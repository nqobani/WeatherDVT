//
//  Extensions.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation
import UIKit

extension Double{
    func toDegreescelsius() -> String {
        return String(format: "%.0f\("º")",self)
    }
}

extension Date{
    func getDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let strDate = dateFormatter.string(from: (self))
        return strDate
    }
    
    func getHours() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let strDate = dateFormatter.string(from: (self))
        return strDate
    }
}

extension String {
    func toFullDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:self)!
        return date
    }
    
    func getWeatherIcon() -> UIImage {
        if self.contains("cloud") {
            return #imageLiteral(resourceName: "partlysunny")
        } else if self.contains("clear"){
            return #imageLiteral(resourceName: "clear")
        } else if self.contains("rain"){
            return #imageLiteral(resourceName: "rain")
        } else {
            return #imageLiteral(resourceName: "partlysunny")
        }
    }
    
    func asColor() -> UIColor {
        if self.contains("clear") {
            return #colorLiteral(red: 0.2784313725, green: 0.6705882353, blue: 0.1843137255, alpha: 1)
        } else if self.contains("cloud"){
            return #colorLiteral(red: 0.3291435242, green: 0.4458062649, blue: 0.4831085801, alpha: 1)
        } else {
            return #colorLiteral(red: 0.3412874341, green: 0.3408595324, blue: 0.362621069, alpha: 1)
        }
    }
    
    func asImage() -> UIImage {
        if self.contains("clear") {
            return #imageLiteral(resourceName: "sea_sunny")
        } else if self.contains("cloud"){
            return #imageLiteral(resourceName: "sea_cloudy")
        } else {
            return #imageLiteral(resourceName: "sea_rainy")
        }
    }
}
