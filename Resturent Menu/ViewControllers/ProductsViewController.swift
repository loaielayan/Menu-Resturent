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
        populateNestedArray(array: products)
        
    }
    
    var currentSection = 0
    @IBAction func previousButton(_ sender: Any) {
        if currentSection > 0{
            currentSection = currentSection - 1
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: currentSection), at: .left, animated: true)
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        print(nestedArray.count)
        if currentSection < nestedArray.count - 1{
            currentSection = currentSection + 1
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: currentSection), at: .right, animated: true)
            
        }
    }
    
    var nestedArray = [[Product]]()
    func populateNestedArray(array: [Product])
    {
        
        var counter = 0
        var innerArray = [Product]()
        for (index,item) in array.enumerated()
        {
            innerArray.append(item)
            counter = counter + 1
            if counter == 20 || index == array.endIndex - 1{
                nestedArray.append(innerArray)
                innerArray.removeAll()
                counter = 0
            }
            
            
        }
        
        
        
        print(nestedArray)
        collectionView.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return nestedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nestedArray[section].count //return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        cell.productLabel.text = nestedArray[indexPath.section][indexPath.row].name
        cell.productImageView.sd_setImage(with: URL(string: nestedArray[indexPath.section][indexPath.row].image ?? "")) { (image, error, cacheType, url) in
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width //- 20
        let height = collectionView.frame.size.height
        return CGSize(width: width / 4.0 , height: height / 4.0)//return CGSize(width: width / 4.0 , height: width / 5.0)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }

    
    //var selectedCategory : Category?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.navigationController?.popViewController(animated: true)
        self.delegate?.show(product: nestedArray[indexPath.section][indexPath.row])
    }
    

    
    
    



}

protocol ShowProduct {
    func show(product: Product)
}
