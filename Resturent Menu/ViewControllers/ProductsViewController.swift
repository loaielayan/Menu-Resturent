//
//  ProductsViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import UIKit
import RealmSwift
import SDWebImage

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var delegate: ShowProduct?
    var selectedCategory: Category?
    let realm = try! Realm()
    
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionViewLayout.minimumLineSpacing = 0
        //collectionView.collectionViewLayout = CenterCellCollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let id = selectedCategory!.id!
        products = Array(realm.objects(Product.self).filter("category.id == '\(id)'"))
        populateNestedArray(array: products)
        
        
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.layoutSubviews()
        self.collectionView.setNeedsDisplay()
        //xValue = self.collectionView.bounds.size.width
    }
    
    var currentSection = 0
    var xValue:CGFloat?
    @IBAction func previousButton(_ sender: Any) {
//        if xValue! > self.collectionView.bounds.size.width{
//
//        }
        if currentSection > 0{
            currentSection = currentSection - 1
//            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: currentSection), at: .left, animated: true)
            self.lastContentOffset = self.lastContentOffset - 750//collectionView.bounds.size.width - 25 //- 10
            self.collectionView.setContentOffset(CGPoint(x: lastContentOffset, y: 0.0), animated: true)
        }
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        //print(nestedArray.count)
//        self.collectionView.scrollRectToVisible(CGRect(x: xValue!, y: 0, width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height), animated: true)
//        xValue = xValue! + self.collectionView.frame.size.width
        
        if currentSection < nestedArray.count - 1{
            currentSection = currentSection + 1
            //print(currentSection)
//            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: currentSection), at: .right, animated: true)
            self.lastContentOffset = self.lastContentOffset + 750//collectionView.bounds.size.width - 25//- 10
            self.collectionView.setContentOffset(CGPoint(x: lastContentOffset, y: 0.0), animated: true)

        }
    }
    
    private var lastContentOffset: CGFloat = 0
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.x) {
            // move left
            self.currentSection = self.currentSection - 1
        }
        else if (self.lastContentOffset < scrollView.contentOffset.x) {
           // move rigt
            
            self.currentSection = self.currentSection + 1
        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.x
        print(scrollView.contentOffset.x)
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
        
        
        
        print(nestedArray.count)
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
        
        
        let width = collectionView.frame.size.width - 20
        let height = collectionView.frame.size.height
        return CGSize(width: width / 4.0 , height: width / 5.0)
        

        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.navigationController?.popViewController(animated: true)
        self.delegate?.show(product: nestedArray[indexPath.section][indexPath.row])
    }
    
    //
//    private var indexOfCellBeforeDragging = 0
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        configureCollectionViewLayoutItemSize()
//    }
//
//    private func calculateSectionInset() -> CGFloat {
//        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
//        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
//        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
//        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
//
//        let buttonWidth: CGFloat = 50
//
//        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
//        return inset
//    }
//
//    private func configureCollectionViewLayoutItemSize() {
//        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
//        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//
//        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
//    }
//
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = collectionViewLayout.itemSize.width
//        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
//        let index = Int(round(proportionalOffset))
//        let safeIndex = max(0, min(nestedArray.count - 1, index))
//        return safeIndex
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexOfCellBeforeDragging = indexOfMajorCell()
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // Stop scrollView sliding:
//        targetContentOffset.pointee = scrollView.contentOffset
//
//        // calculate where scrollView should snap to:
//        let indexOfMajorCell = self.indexOfMajorCell()
//
//        // calculate conditions:
//        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
//        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < nestedArray.count && velocity.x > swipeVelocityThreshold
//        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//
//        if didUseSwipeToSkipCell {
//
//            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
//
//            // Damping equal 1 => no oscillations => decay animation:
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                scrollView.layoutIfNeeded()
//            }, completion: nil)
//
//        } else {
//            // This is a much better way to scroll to a cell:
//            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//    }
//

    
 //
    



}

protocol ShowProduct {
    func show(product: Product)
}
