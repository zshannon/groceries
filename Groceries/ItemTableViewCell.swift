//
//  ItemTableViewcell.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var quantityLabel: UILabel?
  
  var item: Item? {
    didSet {
      renderCell()
    }
  }
  
  func renderCell() {
    if let item = item {
      // TODO: render cell
      nameLabel?.text = item.name
      quantityLabel?.text = "\(item.quantity)x"
    }
  }
  
}
