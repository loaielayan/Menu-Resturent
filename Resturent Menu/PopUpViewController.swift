//
//  PopUpViewController.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/18/21.
//

import UIKit
import SDWebImage

class PopUpViewController: UIViewController {
    
    var product: Product?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.containerView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.cornerRadius = 15
        
        
        self.productImage.sd_setImage(with: URL(string: self.product!.image ?? "")) { (image, error, cachetype, url) in

        }
        self.productName.text = self.product!.name
        self.productPrice.text = "\(self.product!.price)"
        
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
