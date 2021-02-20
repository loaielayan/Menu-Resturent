//
//  CategoryOutterCollectionViewCell.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/19/21.
//

import UIKit

class CategoryOutterCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    var data: [Product]?
    
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        cell.productLabel.text = data![indexPath.row].name
//        cell.productImageView.sd_setImage(with: URL(string: data![indexPath.row].image ?? "")) { (image, error, cacheType, url) in
//            
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width / 4, height: height / 5)
    }
    
    
}
