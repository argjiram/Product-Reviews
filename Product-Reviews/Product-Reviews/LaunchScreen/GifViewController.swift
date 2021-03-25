//
//  GifViewController.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/23/21.
//

import UIKit

class GifViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGif()
        continueToAllProductsScreen()
    }
    
    func setupGif(){
        let logoGif = UIImage.gifImageWithName("gif")
        gifImageView.image = logoGif
    }
    
    func continueToAllProductsScreen(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
