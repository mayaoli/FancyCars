//
//  ViewController.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-21.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

protocol CarListViewInterface: BaseViewInterface {
  var presentedCarNum: Int { get }

  func renderCarList()
  func showSpinner()
  func removeSpinner()
}

class ViewController: BaseViewController, CarListViewInterface {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var spinnerView: UIImageView!
  
  var presentedCarNum: Int = 0
  
  private var presenter : ControlPresenter!
  
  // MARK: - Private Methods
  var prensentableCarList: [CarModel] = [] {
    didSet {
      presentedCarNum = prensentableCarList.count
      
      if Thread.isMainThread {
        self.tableView.reloadData()
        self.removeSpinner()
      } else {
        DispatchQueue.main.async {
          self.tableView.reloadData()
          self.removeSpinner()
        }
      }
    }
  }
  
  weak var eventHandler: CarsEventsInterface? {
    return presenter
  }
  
  // MARK: - following 2 functions could be defined a parent class (ex. baseViewControl)
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    (self.eventHandler as? ControlPresenter)?.view = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    
    presenter = ControlPresenter()
    presenter.view = self
  }
  
  // MARK: - Private Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startRotatingSpinner()
    
    self.tableView.register(UINib(nibName: "CarListCellView", bundle: nil), forCellReuseIdentifier: TableViewCellReuseIdentifier.CarListCell.rawValue)
    
    self.navigationItem.leftBarButtonItem = {
      let temp = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
      temp.accessibilityLabel = "Refresh"
      return temp
    }()
    self.title = "Fancy Cars"
    self.navigationItem.rightBarButtonItem = {
      let temp = UIBarButtonItem(image: UIImage(named: "Sort"), style: .plain, target: self, action: #selector(self.sortButtonTapped))
      temp.accessibilityLabel = "Sort"
      return temp
    }()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.eventHandler?.getCarList()
  }
  
  func renderCarList() {
    self.prensentableCarList = (self.eventHandler?.carList)!
  }
  
  private func startRotatingSpinner() {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.fromValue = NSNumber(value: 0 as Float)
    animation.toValue = NSNumber(value: 2 * Float.pi)
    animation.duration = 1.0
    animation.repeatCount = Float.infinity
    self.spinnerView.layer.add(animation, forKey: "spin")
    showSpinner()
  }
  
  func showSpinner() {
    self.spinnerView.isHidden = false
  }
  
  func removeSpinner() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      self.spinnerView.isHidden = true
    })
  }
  
  @objc func sortButtonTapped() {
    self.present(PopupMenuViewController(self.eventHandler?.getMenuItemList, self), animated: true, completion: nil)
  }
  
  @objc func sortByName() {
    prensentableCarList = []
    self.eventHandler?.getSortedList(.name)
  }
  
  @objc func sortByAvailability() {
    prensentableCarList = []
    self.eventHandler?.getSortedList(.availability)
  }
  
  @objc func refresh() {
    self.showSpinner()
    prensentableCarList = []
    self.eventHandler?.getCarList()
  }
}

//MARK: - UITableViewDataSource - just for seggregation
extension ViewController: UITableViewDataSource, CarListViewCellDelegate {
  
  func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
  {
    return prensentableCarList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell( withIdentifier: TableViewCellReuseIdentifier.CarListCell.rawValue, for: indexPath) as! CarListViewCell
    
    cell.delegate = self
    cell.carInfo = prensentableCarList[indexPath.row]
    
    return cell
  }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    //Bottom Refresh
    
    if scrollView == tableView{
      
      if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
      {
        // could add refresh control
        self.eventHandler?.fetchMore(self.presentedCarNum)
      }
    }
  }
}






