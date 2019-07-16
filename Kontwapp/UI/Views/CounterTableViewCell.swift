//
//  CounterTableViewCell.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/14/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import UIKit

protocol CounterChangedDelegate : class {
  func counterChanged(_ counter: Counter)
}

class CounterTableViewCell : UITableViewCell {
  
  @IBOutlet weak var counterNameLabel: UILabel!
  @IBOutlet weak var incButton: UIButton!
  @IBOutlet weak var decButton : UIButton!
  @IBOutlet weak var countLabel: UILabel!
  fileprivate var counter : Counter?
  weak var delegate : CounterChangedDelegate?
  
  func setupCell(counter : Counter){
    self.counterNameLabel.text = counter.title ?? "No name"
    self.countLabel.text = "\(counter.count)"
    self.counter = counter
    self.decButton.isHidden = counter.count == 0
  }
  
  @IBAction func increaseCount(_ sender: Any) {
    guard let counter = self.counter,
          let countText = self.countLabel.text,
          let currentCount = Int(countText) else { return }
    CounterDataHandler.increaseCounter(counter: counter) { success in
      if success {
        self.countLabel.text = "\(currentCount + 1)"
        self.decButton.isHidden = false
        self.delegate?.counterChanged(counter)
      }
    }
  }
  
  @IBAction func decreaseCount(_ sender: Any) {
    guard let counter = self.counter,
      let countText = self.countLabel.text,
      let currentCount = Int(countText) else { return }
    CounterDataHandler.decreaseCounter(counter: counter) { success in
      if success {
        self.countLabel.text = "\(currentCount - 1)"
        self.decButton.isHidden = (currentCount - 1) == 0
        self.delegate?.counterChanged(counter)
      }
    }
  }
  
}

