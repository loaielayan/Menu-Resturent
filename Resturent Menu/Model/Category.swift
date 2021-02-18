//
//  Category.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import Foundation
import RealmSwift

class Category: Object, Codable {


    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var image: String?
  

}

struct Categories: Codable {
  
  let data: [Category]
  

    
}
