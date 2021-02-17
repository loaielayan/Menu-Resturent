//
//  Category.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import Foundation
import RealmSwift

class Category: Object, Codable {


    @objc var id: String?
    @objc var name: String?
    @objc var image: String?
  

}

struct Categories: Codable {
  
  let data: [Category]
  

    
}
