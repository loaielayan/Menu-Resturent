//
//  Product.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import Foundation
import RealmSwift

class Product: Object, Codable {


    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    
    @objc dynamic var category: Category?

}

struct products: Codable {
  
  let data: [Product]
  

    
}
