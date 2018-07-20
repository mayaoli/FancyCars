//
//  ControlPresenter.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation

protocol ModelInteractorOutput: class {
  func gotResponseError(_ error: NetworkingError)
  func gotCarList(_ response: [CarModel])
  func gotCheckStatus()
}

protocol CarsEventsInterface: class {
  var carList: [CarModel] { get }
  var getMenuItemList: [(String, Any?)]! { get }
  
  func getCarList()
  func checkCarAvailability(_ cars: [CarModel])
  func fetchMore(_ presentedCarNum: Int)
  func getSortedList(_ order: SortName)
}

class ControlPresenter: BasePresenter {
  weak var view: CarListViewInterface?
  
  weak var interactor: ModelInteractorInput? {
    return model
  }
  
  var model: ModelInteractor!
  
  var _allCars: [CarModel] = []
  var allCars: [CarModel] {
    get {
      if !_allCars.isEmpty {
        return _allCars
      } else if let cachedVersion = StorageManager.getObject(path: Constants.STORAGE_PATH) {
        // use the cached version
        return cachedVersion as! [CarModel]
      }
      return []
    }
    set {
      _allCars = newValue
      StorageManager.setObject(arrayToSave: newValue as NSArray, path: Constants.STORAGE_PATH)
    }
  }
  
  override init() {
    super.init()
    
    model = ModelInteractor()
    model.output = self
  }
}

extension ControlPresenter: ModelInteractorOutput {
  func gotResponseError(_ error: NetworkingError) {
    self.view?.renderError(error)
    self.view?.renderCarList()
  }
  
  func gotCarList(_ response: [CarModel]) {
    allCars = response
    
    // check top # cars only instead of allCars, for better performance
    self.checkCarAvailability(self.carList)
  }
  
  func gotCheckStatus() {
    StorageManager.setObject(arrayToSave: _allCars as NSArray, path: Constants.STORAGE_PATH)
    self.view?.renderCarList()
  }
  
  func getSortedList(_ order: SortName) {
    // Order the existing car list
    
    switch order {
    case .name:
      allCars = allCars.sorted(by: { $0.name < $1.name })
    case .availability:
      allCars = allCars.sorted(by: { $0.availability?.rawValue ?? "" > $1.availability?.rawValue ?? "" })
    }
    
    self.checkCarAvailability(self.carList)
  }

}

extension ControlPresenter: CarsEventsInterface {
  var carList: [CarModel] {
    let total = (self.view?.presentedCarNum ?? 0) + Constants.BUNDLE_NUMBER
    
    print("present total: \(total)")
    return self.allCars.count <= total ? self.allCars : Array(self.allCars[0..<total])
  }
  
  var getMenuItemList: [(String, Any?)]! {
    let arr: [(String, Any?)]! = [("name", #selector(ViewController.sortByName)), ("availability", #selector(ViewController.sortByAvailability))]
    return arr
  }
  
  func getCarList() {
    self.interactor?.getCarList()
  }
  
  func checkCarAvailability(_ cars: [CarModel]) {
    guard cars.count > 0 else {
      return
    }
    
    // check only last 10 (or < 10), which is define in Constants
    let remainder = cars.count % Constants.BUNDLE_NUMBER
    let startIdx = cars.count - (remainder==0 ? Constants.BUNDLE_NUMBER : remainder)
    let cars2Check = Array(cars[startIdx..<cars.count])
    
    self.interactor?.checkCarAvailability(cars2Check)
  }
  
  func fetchMore(_ presentedCarNum: Int) {
    let fetch = self.carList
    if presentedCarNum < fetch.count {
      self.view?.showSpinner()
      self.checkCarAvailability(fetch)
    } else {
      self.view?.removeSpinner()
    }
  }

}
