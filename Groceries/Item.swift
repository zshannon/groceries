//
//  Item.swift
//  Groceries
//
//  Created by Zane Shannon on 7/29/16.
//  Copyright © 2016 Zane Shannon. All rights reserved.
//

import Foundation
import PromiseKit
import RealmSwift

class Item: Object {
  
  dynamic var id = NSUUID().UUIDString
  dynamic var name = ""
  dynamic var shortDescription = ""
  dynamic var quantity = 1
  dynamic var completedAt: NSDate? = nil
  dynamic var createdAt = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  static func all() -> Results<Item>? {
    return try! Realm().objects(Item).sorted("createdAt")
  }
  
  func markCompleted() -> Promise<Bool> {
    return Promise { resolve, reject in
      let id = self.id
      Queue.global.async({
        do {
          let realm = try Realm()
          if let item = realm.objectForPrimaryKey(Item.self, key: id) {
            try realm.write({
              item.completedAt = NSDate()
              Queue.main.async({ 
                resolve(true)
              })
            })
          }
          else {
            reject(NSError(domain: "me.zcs.groceries", code: 404, userInfo: nil))
          }
        }
        catch let error {
          reject(error)
        }
      })
    }
  }
  
  func save() -> Promise<Bool> {
    return Promise { resolve, reject in
      Queue.main.async({
        do {
          let realm = try Realm()
          try realm.write({
            realm.add(self, update: true)
            Queue.main.async({
              resolve(true)
            })
          })
        }
        catch let error {
          reject(error)
        }
      })
    }
  }
  
  func destroy() -> Promise<Bool> {
    return Promise { resolve, reject in
      let id = self.id
      Queue.global.async({
        do {
          let realm = try Realm()
          if let item = realm.objectForPrimaryKey(Item.self, key: id) {
            try realm.write({
              realm.delete(item)
              Queue.main.async({
                resolve(true)
              })
            })
          }
          else {
            reject(NSError(domain: "me.zcs.groceries", code: 404, userInfo: nil))
          }
        }
        catch let error {
          reject(error)
        }
      })
    }
  }
  
}