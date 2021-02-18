//
//  ProductsViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import UIKit
import RealmSwift
import SDWebImage

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ShowProduct?
    var selectedCategory: Category?
    let realm = try! Realm()
    
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let id = selectedCategory!.id!
        products = Array(realm.objects(Product.self).filter("category.id == '\(id)'"))
        print(products.count)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        cell.productLabel.text = products[indexPath.row].name
        cell.productImageView.sd_setImage(with: URL(string: products[indexPath.row].image ?? "")) { (image, error, cacheType, url) in
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    //var selectedCategory : Category?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.navigationController?.popViewController(animated: true)
        self.delegate?.show(product: products[indexPath.row])
    }
    

    
    
    



}

protocol ShowProduct {
    func show(product: Product)
}
