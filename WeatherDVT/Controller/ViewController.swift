//
//  ViewController.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/14.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {

    var forecast = ForecastResponse()
    var locationManager: CLLocationManager!
    var weatherClient = WeatherClient()
    var googlePlacesClient = GooglePlacesClient()
    let reachability = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.backgroundColor = "clear".asColor()
        self.forecastTableview.backgroundColor = "clear".asColor()
        
        self.tableviewSetup()
        
        reachability?.startListening(onUpdatePerforming: { _ in
            if let isNetworkReachable = self.reachability?.isReachable,
                isNetworkReachable == true {
                self.setupLocationManager()
                self.offlineLabel.isHidden = true
            } else {
                self.offlineLabel.isHidden = false
            }
        })
        
        weatherClient.currentWeatherdelegate = self
        weatherClient.weatherForecastDelegate = self
        googlePlacesClient.placeDetailsDelegate = self
        googlePlacesClient.searchPlaceDelegate = self
    }
        
    func getWeather(lat: Double, lon: Double){
        if activityInicator != nil {
            activityInicator.startAnimating()
        }
        weatherClient.getCurrentWeather(lat: lat, lon: lon)
        weatherClient.getWeatherForecast(lat: lat, lon: lon)
    }
    
    func updateUI(_ currentWeather: CurrentWeatherResponse) {
        let description = currentWeather.weather[0].description
        self.backgroundView.backgroundColor = description.asColor()
        self.forecastTableview.backgroundColor = description.asColor()
        self.weatherImage.image = description.asImage()
        
        currentWeatherDescription.text = currentWeather.weather[0].main
        mainWeatherLabel.text = currentWeather.main.temp.toDegreescelsius()
        minWeatherLabel.text = currentWeather.main.temp_min.toDegreescelsius()
        maxWeatherLabel.text = currentWeather.main.temp_max.toDegreescelsius()
        currentWeatherLabel.text = currentWeather.main.temp.toDegreescelsius()
    }
    
    @IBAction func LoadCurrentLocationWeather(_ sender: Any) {
        setupLocationManager()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if let placeName = searchTextField.text{
            googlePlacesClient.searchPlace(name: placeName)
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var mainWeatherLabel: UILabel!
    @IBOutlet weak var minWeatherLabel: UILabel!
    @IBOutlet weak var maxWeatherLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var forecastTableview: UITableView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var activityInicator: UIActivityIndicatorView!
    @IBOutlet weak var offlineLabel: UILabel!
}

extension ViewController: CurrentWeatherDelegate{
    func onCurrentWeatherSuccess(result: CurrentWeatherResponse) {
        DispatchQueue.main.async {
            self.updateUI(result)
        }
    }
    
    func onCurrentWeatherFailure(err: Error) {
        print(err)
    }
}

extension ViewController: WeatherForecastDelegate{
    func onWeatherForecastSuccess(result: ForecastResponse) {
        DispatchQueue.main.async {
            self.forecast = result
            self.forecastTableview.reloadData()
            self.activityInicator.stopAnimating()
        }
    }
    
    func onWeatherForecastFailure(err: Error) {
        DispatchQueue.main.async {
            print(err)
            self.activityInicator.stopAnimating()
        }
    }
}

extension ViewController: GoogleSearchDelegate{
    func onPlaceSearchSuccess(result: SearchResponse) {
        DispatchQueue.main.async {
            self.locationNameLabel.isHidden = false
            if result.candidates.count <= 0{
                self.locationNameLabel.text = "Location Not Found"
                return
            }
            
            if let placeID = result.candidates[0].place_id{
                self.googlePlacesClient.getPlaceDetails(plase_id: placeID)
            }
        }
    }
    
    func onPlaceSearchFailure(error: Error) {
        
    }
}

extension ViewController: PlaceDetailsDelegate{
    func onPlaceDetailsSuccess(result: PlaseDetailsResponse) {
        DispatchQueue.main.async {
            let lat = result.result.geometry.location.lat
            let lon = result.result.geometry.location.lng
            self.locationNameLabel.text = result.result.formattedAddress
            self.getWeather(lat: lat, lon: lon)
        }
    }
    
    func onPlaceDetailsFailure(error: Error) {
        
    }
}

extension ViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        self.locationManager.startUpdatingLocation()
        let location: CLLocationCoordinate2D = self.locationManager.location!.coordinate
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        self.locationManager.stopUpdatingLocation()
        
        if self.locationNameLabel != nil{
            self.locationNameLabel.isHidden = true
        }
        if self.searchTextField != nil {
            self.searchTextField.text = ""
        }
        
        getWeather(lat: lat, lon: lon)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableviewSetup() {
        self.forecastTableview.dataSource = self
        self.forecastTableview.delegate = self
        self.forecastTableview.separatorStyle = .none
        self.forecastTableview.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast == nil ? 0:self.forecast?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell", for: indexPath) as! ForecastTableViewCell
        
        let forecast = self.forecast?.list[indexPath.row]
        
        let date = forecast?.date?.toFullDate()
        if date?.getDay() != Date().getDay() && date?.getHours() == "12:00" {
            cell.temperatureLabel.text = forecast?.main.temp.toDegreescelsius()
            cell.weekDayLabel.text = date?.getDay()
            cell.weatherIcon.image = forecast?.weather[0].description.getWeatherIcon()
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let forecast = self.forecast?.list[indexPath.row]
        let date = forecast?.date?.toFullDate()
        let currentDate = Date()
        if date?.getDay() != currentDate.getDay() && date?.getHours() == "12:00" {
            return 60
        }else{
            return 0
        }
        
    }
    
}

