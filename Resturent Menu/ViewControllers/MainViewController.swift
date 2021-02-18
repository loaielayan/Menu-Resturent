//
//  MainViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import UIKit
import ProgressHUD
import RealmSwift

class MainViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if realm.objects(Category.self).count == 0 {
            
            getCategories()
            
        }else{
            self.collectionView.reloadData()
        }
        
        
        

    }
    
    
    
    @IBAction func previousButton(_ sender: Any) {
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    func getCategories(){
        
        ProgressHUD.show()
        DispatchQueue.global().async {
            RequestManager.getCategories { (categories, error) in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    if error != nil{
                        print(error.debugDescription)
                        let alert = UIAlertController(title: "Failed to get data", message: error?.localizedDescription, preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                            self.getCategories()
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(retryAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    
                    guard let cats = categories else{
                        
                        print("no categories")
                        return
                        
                    }
                    print("number of categories: \(cats.count)")
                    for category in cats{
                        try! self.realm.write {
                            self.realm.add(category)
                        }
                    }
                    self.collectionView.reloadData()
                    self.populateProducts()
                } // main queue

                
                
            }
        } // global queue

    }
    
    func populateProducts(){
        
        DispatchQueue.global().async {
            
            RequestManager.getProducts { (products, error) in
                if error != nil{
                    print(error.debugDescription)
                    let alert = UIAlertController(title: "Failed to get data", message: error?.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                        self.getCategories()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                    alert.addAction(cancelAction)
                    alert.addAction(retryAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                //print(products ?? "no products")
                guard let prods = products else{
                    
                    print("no products")
                    return
                    
                }
                for product in prods{
                    try! self.realm.write {
                        self.realm.add(product)
                    }
                }
                print("number of products: \(prods.count)")
            } // get products
        } // global queue
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm.objects(Category.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        cell.categoryLabel.text = realm.objects(Category.self)[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 150)
    }
    
    var selectedCategory : Category?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = realm.objects(Category.self)[indexPath.row]
        self.performSegue(withIdentifier: "ShowProducts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProducts"{
            if let des = segue.destination as? ProductsViewController{
                des.selectedCategory = self.selectedCategory
            }
        }
        
    }
    

}


