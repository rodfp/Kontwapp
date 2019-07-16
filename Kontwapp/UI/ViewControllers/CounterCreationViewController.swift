//
//  CounterCreationViewController.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/14/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import Foundation
import UIKit

class CounterCreationViewController : UIViewController {
  
  @IBOutlet weak var createButton: UIButton!
  @IBOutlet weak var counterTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.counterTextField.becomeFirstResponder()
    self.counterTextField.delegate = self
    self.createButton.isEnabled = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .default
  }
  
  @IBAction func dismissAction(_ sender: Any) {
    self.dismissScreen()
  }
  
  @IBAction func createNewCounterAction(_ sender: Any) {
    guard let newCounterName = self.counterTextField.text else { return }
    CounterDataHandler.createCounter(title: newCounterName) { success in
      if success{
        self.dismissScreen()
      }else{
        self.showAlert(title: "Error creating counter", message: "Kontwapp couldn't create the counter. Please try again.")
      }
    }
    
  }
  
  fileprivate func dismissScreen(){
    DispatchQueue.main.async {
      self.counterTextField.resignFirstResponder()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  fileprivate func showAlert(title : String, message: String){
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true)
    }
  }
  
  @IBAction func textFieldChanged(_ sender: UITextField) {
    guard let text = sender.text else { return }
    self.createButton.isEnabled = !text.isEmpty
  }
  
  
}

extension CounterCreationViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.counterTextField.resignFirstResponder()
    return false
  }
  
}
