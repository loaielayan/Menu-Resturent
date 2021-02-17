//
//  MainViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import UIKit
import ProgressHUD
//import RealmSwift

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let realm = try! Realm()
        
        ProgressHUD.show()
        RequestManager.getCategories { (categories, error) in
            ProgressHUD.dismiss()
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            
//            guard let cats = categories else{return}
//            for category in cats{
//                try! realm.write {
//                    realm.add(category)
//                }
//            }
            
        }
        
        //let cats = realm.objects(Category.self)
        
        //print(cats)

    }
    


}
