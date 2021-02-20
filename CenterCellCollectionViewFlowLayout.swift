//
//  CenterCellCollectionViewFlowLayout.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/20/21.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        self.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.scrollDirection = .horizontal
        
 //       guard let collectionView = collectionView else { return }
        
//        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
//        let maxNumColumns = Int(availableWidth / minColumnWidth)
//        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
//        self.itemSize = CGSize(width: 150, height: 150)
//        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
//        self.sectionInsetReference = .fromSafeArea
    }

}
