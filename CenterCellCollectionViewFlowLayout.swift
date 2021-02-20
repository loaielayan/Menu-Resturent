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
    }

}
