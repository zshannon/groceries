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
  
  @IBAction func save(sender: AnyObject) {
    item.name = "Hello World"
    item.shortDescription = "Hello World"
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
