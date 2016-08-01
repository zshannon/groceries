//
//  ItemTableViewcell.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  @IBOutlet weak var completedButton: UIButton?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var quantityLabel: UILabel?
  
  var item: Item? {
    didSet {
      renderCell()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    completedButton?.layer.borderColor = UIColor.blackColor().CGColor
    completedButton?.layer.borderWidth = 4.0
    completedButton?.layer.cornerRadius = 8.0
  }
  
  func renderCell() {
    if let item = item {
      let attributedString = NSMutableAttributedString(string: item.name)
      if item.completed {
        attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedString.length))
      }
      completedButton?.setTitle(item.completed ? "✔" : "", forState: .Normal)
      nameLabel?.attributedText = attributedString
      quantityLabel?.text = "\(item.quantity)x"
    }
  }
  
  @IBAction func tappedCompletedButton(sender: AnyObject?) {
    if let item = item {
      item.markCompleted(!item.completed)
    }
  }
  
}
