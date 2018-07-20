//
//  CarListViewCell.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

protocol CarListViewCellDelegate: class {
  func renderMessage(title: String, message: String)
}

class CarListViewCell: UITableViewCell {
  
  @IBOutlet weak var carImage: UIImageView!
  @IBOutlet weak var carName: UILabel!
  @IBOutlet weak var carModel: UILabel!
  @IBOutlet weak var carYear: UILabel!
  @IBOutlet weak var carAvailability: UILabel!
  @IBOutlet weak var carMaker: UILabel!
  @IBOutlet weak var buyButon: UIButton!

  weak var delegate: CarListViewCellDelegate?
  
  var carInfo: CarModel! {
    didSet {
      if let url = carInfo.imageURL {
        carImage.imageFromUrl(url)
      } else {
        carImage.image = nil
      }
      
      carName.text = carInfo.name
      carModel.text = carInfo.model
      carYear.text = carInfo.year
      carMaker.text = carInfo.maker
      carAvailability.text = carInfo.availability?.rawValue
      
      buyButon.isHidden = (carInfo.availability != .InDealership)
      
      // just an example of accessibility
      accessibilityIdentifier = carInfo.name
    }
  }

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

  @IBAction func buyButtonTapped(_ sender: Any) {
    self.delegate?.renderMessage(title: "Confirm", message: "You droped an offer for \(carInfo.name) - \(carInfo.year)|\(carInfo.model).\n\nThank you for your business, looking forward to talking to you!")
  }
}
