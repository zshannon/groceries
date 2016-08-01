//
//  MasterViewController.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import DZNEmptyDataSet
import PromiseKit
import RealmSwift
import UIKit

class ItemsViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

  var items = Results<Item>?()
  var token: NotificationToken? {
    didSet {
      oldValue?.stop()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    tableView.tableFooterView = UIView()
    
    self.items = Item.all()
    self.token = self.items?.addNotificationBlock({ changes in
      guard let tableView = self.tableView else { return }
      switch changes {
      case .Initial:
        tableView.reloadData()
        break
      case .Update(_, let deletions, let insertions, let modifications):
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
          withRowAnimation: .Automatic)
        tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
          withRowAnimation: .Automatic)
        tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
          withRowAnimation: .Automatic)
        tableView.endUpdates()
        break
      case .Error(let error):
        fatalError("\(error)")
        break
      }
    })
  }

  // MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Items#show" {
      if let indexPath = self.tableView.indexPathForSelectedRow, controller = segue.destinationViewController as? ItemViewController {
        controller.item = items![indexPath.row]
      }
    }
    else if segue.identifier == "Items#new" {
      if let controller = segue.destinationViewController as? ItemViewController {
        controller.item = Item()
      }
    }
  }

  // MARK: - Table View

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items?.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)

    if let item = self.items?[indexPath.row], cell = cell as? ItemTableViewCell {
      cell.item = item
    }
    
    return cell
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      if let item = self.items?[indexPath.row] {
        item.destroy()
      }
    }
    else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }

  // MARK: - DZNEmptyDataSetDelegate
  
  func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
    return self.items?.count ?? 0 == 0
  }
  
  // MARK: - DZNEmptyDataSetSource
  
  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let str = "No Items"
    let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
    let str = "What are you hungry for?"
    let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
    let str = "+ Add Item"
    let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
    self.performSegueWithIdentifier("Items#new", sender: self)
  }
  
}

