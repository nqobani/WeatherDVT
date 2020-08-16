//
//  WeatherDVTTests.swift
//  WeatherDVTTests
//
//  Created by Nqobani Zulu on 2020/08/14.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import XCTest
@testable import WeatherDVT
import CoreLocation

class WeatherDVTTests: XCTestCase, WeatherForecastDelegate, CurrentWeatherDelegate, GoogleSearchDelegate, PlaceDetailsDelegate {
    
    var homeViewController: ViewController!
    var weatherClient: WeatherClient!
    var googlePlacesClient: GooglePlacesClient!
    var currentLocation: CLLocationCoordinate2D!
    
    private var testCurrentWeatherExpectation: XCTestExpectation!
    private var testWeatherForecastExpectation: XCTestExpectation!
    private var testGooglePlaceSearchExpectation: XCTestExpectation!
    private var testPlaceDetailsExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        self.homeViewController = ViewController()
        self.weatherClient = WeatherClient()
        self.googlePlacesClient = GooglePlacesClient()
        self.homeViewController.setupLocationManager()
        self.currentLocation = homeViewController.getCurrentLocation()
        self.weatherClient.currentWeatherdelegate = self
        self.weatherClient.weatherForecastDelegate = self
        self.googlePlacesClient.searchPlaceDelegate = self
        self.googlePlacesClient.placeDetailsDelegate = self
    }
    
    func testLocation() {
         XCTAssertNotNil(currentLocation)
    }

    func testCurrentWeather() {
        testCurrentWeatherExpectation = expectation(description: "Got Current Weather")
        let lat = self.currentLocation.latitude
        let lon = self.currentLocation.longitude
        weatherClient.getCurrentWeather(lat: lat, lon: lon)
        waitForExpectations(timeout: 10)
    }
    
    func onCurrentWeatherSuccess(result: CurrentWeatherResponse) {
        XCTAssertNotNil(result)
        testCurrentWeatherExpectation.fulfill()
    }
    
    func onCurrentWeatherFailure(err: Error) {
        XCTAssertNotNil(err)
        testCurrentWeatherExpectation.fulfill()
    }
    
    func testWeatherForecast() {
        testWeatherForecastExpectation = expectation(description: "Got Weather Forecast")
        let lat = self.currentLocation.latitude
        let lon = self.currentLocation.longitude
        weatherClient.getWeatherForecast(lat: lat, lon: lon)
        waitForExpectations(timeout: 10)
    }
    
    func onWeatherForecastSuccess(result: ForecastResponse) {
        XCTAssertNotNil(result)
        testWeatherForecastExpectation.fulfill()
    }
    
    func onWeatherForecastFailure(err: Error) {
        XCTAssertNotNil(err)
        testWeatherForecastExpectation.fulfill()
    }

    func testPlaceSearch(){
        testGooglePlaceSearchExpectation = expectation(description: "Found Place")
        googlePlacesClient.searchPlace(name: "durban")
        waitForExpectations(timeout: 10)
    }
    
    func onPlaceSearchSuccess(result: SearchResponse) {
        XCTAssertNotNil(result)
        testGooglePlaceSearchExpectation.fulfill()
    }
    
    func onPlaceSearchFailure(error: Error) {
        XCTAssertNotNil(error)
        testGooglePlaceSearchExpectation.fulfill()
    }
    
    
    func testGetPlaceDetails(){
        testPlaceDetailsExpectation = expectation(description: "Got Place Details")
        googlePlacesClient.getPlaceDetails(plase_id: "ChIJt2G8AQCq9x4RgW6qxEZVp8w")
        waitForExpectations(timeout: 10)
    }
    
    func onPlaceDetailsSuccess(result: PlaseDetailsResponse) {
        XCTAssertNotNil(result)
        testPlaceDetailsExpectation.fulfill()
    }
    
    func onPlaceDetailsFailure(error: Error) {
        XCTAssertNotNil(error)
        testPlaceDetailsExpectation.fulfill()
    }
       
    
}
