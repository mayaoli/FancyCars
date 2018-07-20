//
//  ModelInteractor.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

protocol ModelInteractorInput: class {
  ///
  func getCarList()
  func checkCarAvailability(_ cars: [CarModel])
}

class ModelInteractor: BaseInteractor {

  weak var output: ModelInteractorOutput? 
  
  let carServices = CarServices()
  
}

// Could define a BaseInteractorInput being inherited by other class
extension ModelInteractor: ModelInteractorInput {
  
  func getCarList() {
    
    _ = self.carServices.getCarList(completion: { (cars, error) in
      guard error == nil else  {
        // could have retry below here
        self.output?.gotResponseError(error!)
        return
      }
      
      self.output?.gotCarList(cars)
    })
  }
  
  // for performance, limited the check up to 10 items
  func checkCarAvailability(_ cars: [CarModel]) {
    guard cars.count > 0 else {
      self.output?.gotResponseError(.requestValidationFailed)
      return
    }
    
    var serviceError: NetworkingError? = nil
    
    // Async call, wait till all the response comes back
    DispatchQueue.global(qos: .default).async {
      
      let serviceGroup = DispatchGroup()
      
      cars.forEach { car in
        
        serviceGroup.enter()
        
        _ = self.carServices.checkCarAvailability(carId: car.cid, completion: { (availability, error) in
          if error != nil  {
            // could have retry below here, just need the first failure message
            if serviceError == nil {
              serviceError = error
            }
          } else {
            car.availability = availability
          }
          serviceGroup.leave()
        })
      }
      
      _ = serviceGroup.wait(timeout: DispatchTime.distantFuture)
      
      if serviceError != nil {
        self.output?.gotResponseError(serviceError!)
      } else {
        self.output?.gotCheckStatus()
      }
      
    }
    
  }
  
}
