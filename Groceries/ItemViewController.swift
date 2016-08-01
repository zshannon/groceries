//
//  ItemViewController.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import RealmSwift
import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  @IBOutlet weak var quantityLabel: UILabel?
  @IBOutlet weak var quantityStepper: UIStepper?
  @IBOutlet weak var nameTextField: UITextField?
  @IBOutlet weak var shortDescriptionTextView: UITextView?
  
  var item: Item? {
    didSet {
      // Update the view.
      self.configureView()
    }
  }

  func configureView() {
    // Update the user interface for the detail item.
    if let item = self.item {
      self.navigationItem.title = (item.name.characters.count > 0) ? item.name : "New Item"
      self.quantityLabel?.text = "\(item.quantity)x"
      self.quantityStepper?.value = Double(item.quantity)
      self.nameTextField?.text = item.name
      if (item.shortDescription.characters.count > 0) {
        self.shortDescriptionTextView?.text = item.shortDescription
        self.shortDescriptionTextView?.textColor = UIColor.blackColor()
      }
      else {
        self.shortDescriptionTextView?.text = textViewPlaceholderText
        self.shortDescriptionTextView?.textColor = UIColor.lightGrayColor()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }

  @IBAction func quantityChanged(sender: UIStepper?) {
    self.quantityLabel?.text = "\(Int(sender!.value))x"
  }
  
  @IBAction func tappedSave(sender: UIBarButtonItem?) {
    sender?.enabled = false
    let realm = try! Realm()
    try! realm.write({
      if let item = self.item {
        item.quantity = Int(self.quantityStepper?.value ?? 1)
        item.name = self.nameTextField?.text ?? item.name
        item.shortDescription = self.shortDescriptionTextView?.text ?? item.shortDescription
        item.shortDescription = item.shortDescription == textViewPlaceholderText ? "" : item.shortDescription
        realm.add(item, update: true)
        if item.name.characters.count == 0 {
          realm.delete(item)
        }
      }
      sender?.enabled = true
      self.navigationController?.popViewControllerAnimated(true)
    })
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    shortDescriptionTextView?.becomeFirstResponder()
    return true
  }
  
  // MARK: - UITextViewDelegate
  
  let textViewPlaceholderText = "Short description..."
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    textView.textColor = UIColor.blackColor()
    if (textView.text == textViewPlaceholderText) {
      textView.text = ""
    }
    return true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if (textView.text.characters.count == 0) {
      textView.text = textViewPlaceholderText
      textView.textColor = UIColor.lightGrayColor()
    }
  }
  
}

