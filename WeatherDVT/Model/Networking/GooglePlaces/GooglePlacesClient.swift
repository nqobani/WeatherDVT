//
//  GooglePlacesClient.swift
//  WeatherDVT
//
//  Created by Nqobani Zulu on 2020/08/15.
//  Copyright © 2020 Nqobani Zulu. All rights reserved.
//

import Foundation

struct GooglePlacesClient {
    let googlePlacesSearchURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=AIzaSyDCGxZr5LY1dRxxqy0b_P1JnqVehMQrI3I&inputtype=textquery&input="
    let googlePlacesDetailsURL = "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDCGxZr5LY1dRxxqy0b_P1JnqVehMQrI3I&place_id="
    
    var searchPlaceDelegate: GoogleSearchDelegate?
    var placeDetailsDelegate: PlaceDetailsDelegate?
    
    func searchPlace(name: String) {
        let urlString = "\(googlePlacesSearchURL)\(name.replacingOccurrences(of: " ", with: "+"))"
        performTask(urlString: urlString, codable: SearchResponse.self, completion: { result in
            switch result{
            case .success(let searchResponse):
                self.searchPlaceDelegate?.onPlaceSearchSuccess(result: searchResponse)
            case .failure(let err):
                self.searchPlaceDelegate?.onPlaceSearchFailure(error: err)
            }
        })
    }
    
    func getPlaceDetails(plase_id: String) {
        let urlString = "\(googlePlacesDetailsURL)\(plase_id)"
        performTask(urlString: urlString, codable: PlaseDetailsResponse.self, completion: { result in
            switch result{
            case .success(let placeDetailsResponse):
                self.placeDetailsDelegate?.onPlaceDetailsSuccess(result: placeDetailsResponse)
            case .failure(let err):
                self.placeDetailsDelegate?.onPlaceDetailsFailure(error: err)
            }
        })
    }
    
    func performTask<T: Decodable>(urlString: String, codable: T.Type, completion: @escaping(Result<T,Error>)->()) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, err: Error?) in
                if let err = err{
                    completion(.failure(err))
                    return
                }
                
                do{
                    let weatherResponse = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(weatherResponse))
                } catch let jsonError{
                    completion(.failure(jsonError))
                }
            }
            task.resume()
        }
    }
}
