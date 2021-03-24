//
//  ProductDetailsViewController.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/24/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var productModel: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductDeatilas()
        setupTableView()
    }
    
    func setupProductDeatilas(){
        if let productModel = productModel {
            productImage.sd_setImage(with: URL(string: productModel.imgUrl), completed: {
                (imageT, error, cacheType, url) in })
            productNameLabel.text = productModel.name
            productDescriptionLabel.text = productModel.description
            productPriceLabel.text = String(productModel.price) + " $"
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 130
    }
    
    @IBAction func addReviewAction(_ sender: Any) {
        
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productModel?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as? ReviewTableViewCell else  {
            return UITableViewCell()
        }
        if let review = productModel?.reviews[indexPath.row] {
            cell.setupReviewCell(review: review)
        }
        return cell
    }
}
