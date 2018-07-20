//
//  CarServices.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

class CarServices: BaseServices {
  

  func getCarList(completion: @escaping (_ cars: [CarModel], _ error: NetworkingError?) -> Void) -> URLSessionTask? {
    
    let urlString = "\(Constants.BASE_URL)/cars"
    
    guard let url = URL(string: urlString) else {
      completion([], .unknown)
      return nil
    }
    
    return get(url: url) { (response, data, error) in
      guard error == nil else {
        completion([], error)
        return
      }
      
      guard data?.type == .json, let json = data?.json else {
        completion([], .responseValidationFailed)
        return
      }
      
      var cars: [CarModel] = []
      do {
        cars = try self.getArray(json, type: CarModel.self)
      } catch _ {
        completion([], .unknown)
      }
      
      completion(cars, nil)
    }
  }
  
  func checkCarAvailability(carId: String, completion: @escaping (_ available: CarAvailibility?, _ error: NetworkingError?) -> Void) -> URLSessionTask? {
    let urlString = "\(Constants.BASE_URL)/availability"
    
    guard let url = URL(string: urlString), !carId.isEmpty else {
      completion(nil, .unknown)
      return nil
    }
    
    let parameters = ["id": "\(carId)"]
    
    return get(url: url, queryParameters: parameters) { (response, data, error) in
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      guard data?.type == .json, let json = data?.json else {
        completion(nil, .responseValidationFailed)
        return
      }
      
      guard let availableString = json["available"].string, let available = CarAvailibility.init(rawValue: availableString) else {
        completion(nil, .responseValidationFailed)
        return
      }
      
      completion(available, nil)
    }
  }
    
}
