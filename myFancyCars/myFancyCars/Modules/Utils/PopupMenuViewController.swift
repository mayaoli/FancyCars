//
//  PopupMenuViewController.swift
//  myFancyCars
//
//  Created by Yaoli Ma on 2018-06-23.
//  Copyright © 2018 Yaoli Ma. All rights reserved.
//

import UIKit

class PopupMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
  
  let dropdownTableview = UITableView(frame: CGRect.zero, style: .grouped)
  
  let cellReuseIdentifier = "cell"
  var menuList: [(String, Any?)]!
  var owner: UIViewController!
  
  init(_ list: [(String, Any?)]!, _ parent: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    
    self.menuList = list
    self.owner = parent
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func loadView() {
    self.view = UIView()
    view.backgroundColor = UIColor.yellow
    self.view.addSubview(self.dropdownTableview)
    let tgr = UITapGestureRecognizer(target: self, action: #selector(PopupMenuViewController.tappedAnywhere(_:)))
    tgr.delegate = self
    self.view.addGestureRecognizer(tgr)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.view.accessibilityIdentifier = "app_loading_page"
    self.view.backgroundColor = UIColor(white: 0x000000, alpha: 0.16)
    
    self.dropdownTableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
    dropdownTableview.delegate = self
    dropdownTableview.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.fromValue = NSNumber(value: 0 as Float)
    animation.toValue = NSNumber(value: 2 * Float.pi)
    animation.duration = 0.6
    animation.repeatCount = 1
    
    self.dropdownTableview.accessibilityIdentifier = "launch_loader"
    
    // Accessibility
    self.dropdownTableview.isAccessibilityElement = true
    self.view.isAccessibilityElement = true
    
    accessibilityElements = [view, dropdownTableview]
    
    view.accessibilityLabel = "Sort Menu"
    view.accessibilityTraits = UIAccessibilityTraitButton
    // AccessibilityEnd
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let iosVersion = NSString(string: UIDevice.current.systemVersion).doubleValue
    self.dropdownTableview.frame = CGRect(x: self.view.bounds.size.width - 196.0, y: UIApplication.shared.statusBarFrame.height, width: 196.0, height: CGFloat(44 * (menuList.count) + (iosVersion < 11 ? 0 : 36)))
    
    dropdownTableview.estimatedSectionHeaderHeight = 0
    dropdownTableview.alwaysBounceVertical = false
    dropdownTableview.isScrollEnabled = false
    
    self.dropdownTableview.layer.shadowOpacity = 1.0
    self.dropdownTableview.layer.shadowRadius = 8.0
    self.dropdownTableview.layer.shadowOffset = CGSize(width:0, height:8)
    self.dropdownTableview.layer.shadowColor = UIColor.gray.cgColor
    self.dropdownTableview.clipsToBounds = false
  }
  
  // MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
      return UITableViewCell()
    }
    let (labelText, _) = menuList[indexPath.row]
    cell.textLabel?.text = "\(labelText)"
    cell.accessibilityTraits = UIAccessibilityTraitLink
    cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.1
  }
  
  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let (_, action) = menuList[indexPath.row]
    if let selector = action as? Selector {
      self.owner.perform(selector)
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == gestureRecognizer.view
  }
  
  @objc private func tappedAnywhere(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      self.dismiss(animated: true, completion: nil)
    }
  }
}
