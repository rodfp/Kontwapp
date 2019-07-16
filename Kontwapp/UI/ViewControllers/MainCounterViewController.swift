//
//  MainCounterViewController.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/14/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import UIKit

class MainCounterViewController : UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalLabel: UILabel!
  
  var counters : [Counter] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.tableFooterView = UIView()
    CounterDataHandler.getAllCounters { (counters) in
      DispatchQueue.main.async {
        self.counters = counters
        self.recalculateTotal()
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNeedsStatusBarAppearanceUpdate()
    self.reloadData()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func createNewCounterAction(_ sender: Any) {
    self.performSegue(withIdentifier: "newCounter", sender: nil)
  }
  
  fileprivate func reloadData(){
    self.recalculateTotal()
    self.tableView.reloadData()
  }
  
  fileprivate func recalculateTotal(){
    self.counters = CounterDataHandler.getAllDeviceStoredCounters()
    var sum : Int16 = 0
    for counter in self.counters {
      sum = sum + counter.count
    }
    self.totalLabel.text = "Total : \(sum)"
  }
  
}

extension MainCounterViewController : UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      CounterDataHandler.deleteCounter(counter: self.counters[indexPath.row]) { success in
        if success{
          self.recalculateTotal()
          tableView.deleteRows(at: [indexPath], with: .none)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return counters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "counterCell", for: indexPath) as? CounterTableViewCell
           else {
      return UITableViewCell()
    }
    let counter = counters[indexPath.row]
    cell.setupCell(counter : counter)
    cell.delegate = self
    return cell
  }
  
}

extension MainCounterViewController : CounterChangedDelegate {
  
  func counterChanged(_ counter: Counter) {
    self.recalculateTotal()
  }
  
}
