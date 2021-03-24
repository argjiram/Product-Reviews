//
//  ProductTableViewCell.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loader.startAnimating()
    }

    func setupCellView(productModel: ProductModel){
        productImage.sd_setImage(with: URL(string: productModel.imgUrl), completed: {
            (imageT, error, cacheType, url) in
            DispatchQueue.main.async {
                self.loader.stopAnimating()
            }
        })
        productNameLabel.text = productModel.name
        productDescriptionLabel.text = productModel.description
        productPriceLabel.text = String(productModel.price) + " $"
    }
}
