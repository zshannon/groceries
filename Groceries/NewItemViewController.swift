//
//  NewItemViewController.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

  let item = Item()
  
  @IBOutlet weak var nameTextField: UITextField?
  @IBOutlet weak var shortDescriptionTextField: UITextField?
  @IBOutlet weak var quantityTextField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.nameTextField?.becomeFirstResponder()
  }
  
  @IBAction func save(sender: AnyObject) {
    item.name = self.nameTextField?.text ?? ""
    item.shortDescription = self.shortDescriptionTextField?.text ?? ""
    item.quantity = Int(self.quantityTextField?.text ?? "0") ?? 0
    item.save().then { result in
      self.dismissViewControllerAnimated(true) {
        
      }
    }
  }
  
  @IBAction func dismiss(sender: AnyObject) {
    self.dismissViewControllerAnimated(true) { 
      
    }
  }
  
}
