//
//  MainViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import UIKit
import ProgressHUD
import RealmSwift

class MainViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ShowProduct {
    

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    let realm = try! Realm()
    
    var page = 1
    //var lastPage: Int?
    
    var productPage = 1
    //var productLastPage: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            //collectionViewLayout.minimumLineSpacing = 0
            //collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            //collectionViewLayout.itemSize = CGSize(width: 300, height: 300)
            self.page = 1
            self.productPage = 1
            
            if self.realm.objects(Category.self).count == 0 {
                
                self.getCategories(pageNumber: self.page)
                
            }else{
                //print(realm.objects(Category.self).filter("isRelatedToProduct == false").count)
                self.populateNestedArray(array: Array(self.realm.objects(Category.self).filter("isRelatedToProduct == false")))
                //self.collectionView.reloadData()
            }
        }



    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.collectionView.layoutSubviews()
            self.collectionView.setNeedsDisplay()
            self.collectionView.reloadData()
        }

        //xValue = self.collectionView.bounds.size.width
    }
    

//    private var lastContentOffset: CGFloat = 0
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if (self.lastContentOffset > scrollView.contentOffset.x) {
//            // move left
//            self.currentSection = self.currentSection - 1
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.x) {
//           // move rigt
//
//            self.currentSection = self.currentSection + 1
//        }
//
//        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.x
//        print(self.lastContentOffset)
//    }
    
    
    
    func show(product: Product) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PopUp") as! PopUpViewController
        vc.product = product
        self.present(vc, animated: true, completion: nil)
    }
    
    var currentSection = 0
    var dataSet = [Category]()
    
    var nestedArray = [[Category]]()
    
    func populateNestedArray(array: [Category])
    {
//        var numberOfInnerArrays = 0
//        if array.count % 20 == 0{
//            numberOfInnerArrays = array.count / 20
//        }else{
//            numberOfInnerArrays = (array.count / 20) + 1
//        }
        var counter = 0
        var innerArray = [Category]()
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


        
        print(nestedArray.count)
        dataSet = nestedArray[0]
        collectionView.reloadData()
        
    }
    
    @IBAction func previousButton(_ sender: Any) {
        
        
//        if currentSection > 0{
//            currentSection = currentSection - 1
//            //self.collectionView.scrollToItem(at: IndexPath(row: 0, section: currentSection), at: .left, animated: true)
//            self.lastContentOffset = self.lastContentOffset - 780//collectionView.bounds.size.width //- 10
//            self.collectionView.setContentOffset(CGPoint(x: lastContentOffset, y: 0.0), animated: true)
//
//        }
        
        if currentSection > 0{
            currentSection = currentSection - 1
            dataSet = nestedArray[currentSection]
            collectionView.reloadData()
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
//        print(nestedArray.count)
//        print(currentSection)
//        if currentSection < nestedArray.count - 1 {
//            currentSection = currentSection + 1
//
//            self.lastContentOffset = self.lastContentOffset + 780
//            print(self.lastContentOffset)
//            self.collectionView.setContentOffset(CGPoint(x: lastContentOffset, y: 0.0), animated: true)
//
//
//        }
        
        if currentSection < nestedArray.count - 1{
            currentSection = currentSection + 1
            dataSet = nestedArray[currentSection]
            collectionView.reloadData()
        }
    }
    
    
    func getCategories(pageNumber: Int){
        
        ProgressHUD.show()
        DispatchQueue.global().async {
            RequestManager.getCategories(pageNumber: pageNumber) { (categories, lastPage, error) in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    if error != nil{
                        print(error.debugDescription)
                        let alert = UIAlertController(title: "Failed to get data", message: error?.localizedDescription, preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                            self.getCategories(pageNumber: pageNumber)
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(retryAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if self.page <= lastPage!{
                        guard let cats = categories else{
                            
                            print("no categories")
                            return
                            
                        }
                        print("number of categories: \(cats.count)")

        
                        for category in cats{
                            category.isRelatedToProduct = false
                            try! self.realm.write {
                                self.realm.add(category)
                            }
                        }

                        self.page += 1
                        self.getCategories(pageNumber: self.page)
                        

                        
                        
                    }else{
                        print(self.realm.objects(Category.self).count)
                        self.populateNestedArray(array: Array(self.realm.objects(Category.self)) )
                        //self.collectionView.reloadData()
                        self.populateProducts(pageNumber: self.productPage)
                    }
                    
  
                } // main queue

                
                
            }
        } // global queue

    }
    
    func populateProducts(pageNumber: Int){
        
        DispatchQueue.global().async {
            
            RequestManager.getProducts(pageNumber: pageNumber) { (products,lastPage, error) in
                //DispatchQueue.main.async {
                    if error != nil{
                        print(error.debugDescription)
                        let alert = UIAlertController(title: "Failed to get data", message: error?.localizedDescription, preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                            self.populateProducts(pageNumber: pageNumber)
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(retryAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                if self.productPage <= lastPage!{
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
                    
                    self.productPage += 1
                    self.populateProducts(pageNumber: self.productPage)
                    
                }else{
                    
                }

  
            } // get products
        } // global queue
        
    }
    

    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        return nestedArray.count
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let totalNumberOfObjects = realm.objects(Category.self).filter("isRelatedToProduct == false").count

        
        return dataSet.count//nestedArray[section].count//totalNumberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
//        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        cell.layer.borderWidth = 0.5
//        cell.layer.cornerRadius = 5
        //let indexCount = indexPath.row + (20 * indexPath.section )
        cell.categoryLabel.text = dataSet[indexPath.row].name//realm.objects(Category.self).filter("isRelatedToProduct == false")[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor( (collectionView.frame.size.width  - 20) / 4.0 )
        let height = floor( ( (collectionView.frame.size.height) / 5.0) - 20)
        return CGSize(width: width  , height: height )
    }
    
    
    
    var selectedCategory : Category?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //DispatchQueue.main.async {
        self.selectedCategory = dataSet[indexPath.row] //self.realm.objects(Category.self)[indexPath.row]
            self.performSegue(withIdentifier: "ShowProducts", sender: self)
        //}

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProducts"{
            if let des = segue.destination as? ProductsViewController{
                des.delegate = self
                des.selectedCategory = self.selectedCategory
            }
        }
        
    }
    

}




