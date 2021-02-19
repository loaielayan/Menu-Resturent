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
    @objc dynamic var isRelatedToProduct: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"

    }
  

}


struct Categories: Codable {
  
let meta: Meta
  let data: [Category]
  

    
}
