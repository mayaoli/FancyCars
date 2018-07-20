//
//  Cars.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import Foundation
import SwiftyJSON

//GET /availability?id=123
//RESPONSE: {available: “In Dealership”}  // all  options are [ “Out of Stock”, “Unavailable”]
//
//GET /cars
//RESPONSE:  [ {id: 1, img: http://myfancycar/image, name: “My Fancy Car”, make: “MyMake”, model: “MyModel”, year: 2018} ….]

class CarModel: NSObject, NSCoding, JSONModel {
  
  // car id
  let cid: String  // Could use UInt here
  
  // image url
  let imageURL: String?
  
  // name
  let name: String
  
  // maker
  let maker: String
  
  // model
  let model: String
  
  // year
  let year: String
  
  // availability
  var availability: CarAvailibility?
  
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.cid, forKey: "id")
    aCoder.encode(self.imageURL, forKey: "img")
    aCoder.encode(self.name, forKey: "name")
    aCoder.encode(self.maker, forKey: "make")
    aCoder.encode(self.model, forKey: "model")
    aCoder.encode(self.year, forKey: "year")
    aCoder.encode(self.availability?.rawValue, forKey: "availability")
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    if let dcid = aDecoder.decodeObject(forKey: "id") as? String{
      cid = dcid
    } else {
      cid = ""
    }
    if let dimageURL = aDecoder.decodeObject(forKey: "img") as? String{
      imageURL = dimageURL
    } else {
      imageURL = ""
    }
    if let dname = aDecoder.decodeObject(forKey: "name") as? String{
      name = dname
    } else {
      name = ""
    }
    if let dmaker = aDecoder.decodeObject(forKey: "make") as? String{
      maker = dmaker
    } else {
      maker = ""
    }
    if let dmodel = aDecoder.decodeObject(forKey: "model") as? String{
      model = dmodel
    } else {
      model = ""
    }
    if let dyear = aDecoder.decodeObject(forKey: "year") as? String{
      year = dyear
    } else {
      year = ""
    }
    if let davailability = aDecoder.decodeObject(forKey: "availability") as? String{
      availability = CarAvailibility.init(rawValue: davailability)
    } else {
      availability = .Unknow
    }
  }
  required init(json: JSON) throws {
    
    cid = json["id"].stringValue
    imageURL = json["img"].stringValue
    name = json["name"].stringValue
    maker = json["make"].stringValue
    model = json["model"].stringValue
    year = json["year"].stringValue
    
  }
  
}
