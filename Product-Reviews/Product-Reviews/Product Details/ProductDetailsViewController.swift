//
//  ProductDetailsViewController.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/24/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
            self.productImage.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16)
        }
    }
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet var popView: UIView!
    @IBOutlet weak var starButtonOne: UIButton!
    @IBOutlet weak var starButtonTwo: UIButton!
    @IBOutlet weak var starButtonThree: UIButton!
    @IBOutlet weak var starButtonFour: UIButton!
    @IBOutlet weak var starButtonFive: UIButton!
    @IBOutlet weak var reviewCommentTextField: UITextView!

    let viewModel = ProductDetailsViewModel(productService: ProductService(), reviewService: ReviewService())
    
    var rating: Int = 0
    var productID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !NetworkManager.isReachable() {
            self.view.makeToast(Constants.INTERNET_CONNECTION, duration: 1.5, position: .bottom)
        } else {
            viewModel.getProductDetails(parameteres: ProductDetailsRequestParameter(id: productID))
        }
        
    }
    
    @IBAction func addReviewAction(_ sender: Any) {
        clearView()
        popView.frame = (CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        popView.alpha = 0
        view.addSubview(popView)
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.popView.alpha = 1.0
        }
    }
    
    @IBAction func closePopupViewAction(_ sender: Any) {
        closePopUPView()
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        rating = sender.tag
        switch sender.tag {
        case 1:
            starButtonOne.tintColor = .systemYellow
            starButtonTwo.tintColor = .white
            starButtonThree.tintColor = .white
            starButtonFour.tintColor = .white
            starButtonFive.tintColor = .white
        case 2:
            starButtonOne.tintColor = .systemYellow
            starButtonTwo.tintColor = .systemYellow
            starButtonThree.tintColor = .white
            starButtonFour.tintColor = .white
            starButtonFive.tintColor = .white
        case 3:
            starButtonOne.tintColor = .systemYellow
            starButtonTwo.tintColor = .systemYellow
            starButtonThree.tintColor = .systemYellow
            starButtonFour.tintColor = .white
            starButtonFive.tintColor = .white
        case 4:
            starButtonOne.tintColor = .systemYellow
            starButtonTwo.tintColor = .systemYellow
            starButtonThree.tintColor = .systemYellow
            starButtonFour.tintColor = .systemYellow
            starButtonFive.tintColor = .white
        case 5:
            starButtonOne.tintColor = .systemYellow
            starButtonTwo.tintColor = .systemYellow
            starButtonThree.tintColor = .systemYellow
            starButtonFour.tintColor = .systemYellow
            starButtonFive.tintColor = .systemYellow
        default:
            break
        }
    }


    @IBAction func submitDataAction(_ sender: Any) {
        if !NetworkManager.isReachable() {
            self.view.makeToast(Constants.INTERNET_CONNECTION, duration: 1.5, position: .bottom)
        } else {
            
            if rating == 0 {
                self.view.makeToast("Please Rate The Product", duration: 1.0, position: .top)
                return
            }
            if reviewCommentTextField.text! == "Tell us what you think..." || reviewCommentTextField.text!.count == 0 {
                self.view.makeToast("Please Write a comment", duration: 1.0, position: .top)
                return
            }
            
            if let productDetails = viewModel.returnProductDetails() {
                viewModel.submitReview(parameters: Review(productId: productDetails.id, locale: Constants.LANGUAGE_CODE ?? "", rating: rating, text: reviewCommentTextField.text!))
            }
        }
    }

}

extension ProductDetailsViewController {
    @objc func closeView(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.2, animations: {
            self.popView.alpha = 0.0
        }, completion: { (value: Bool) in
            self.popView.removeFromSuperview()
        })
    }
    
    func closePopUPView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.popView.alpha = 0.0
        }, completion: { (value: Bool) in
            self.popView.removeFromSuperview()
        })
    }
    
    func setupProductDeatilas(){
        if let productModel = viewModel.returnProductDetails() {
            productImage.sd_setImage(with: URL(string: productModel.imgUrl), completed: {
                                        (imageT, error, cacheType, url) in })
            productNameLabel.text = productModel.name
            productDescriptionLabel.text = productModel.description
            productPriceLabel.text = String(productModel.price) + " $"
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView(_:)))
        self.popView.addGestureRecognizer(gesture)
        reviewCommentTextField.delegate = self
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 60
    }
    
    func clearView(){
        reviewCommentTextField.text = "Tell us what you think..."
        rating = 0
        starButtonOne.tintColor = .white
        starButtonTwo.tintColor = .white
        starButtonThree.tintColor = .white
        starButtonFour.tintColor = .white
        starButtonFive.tintColor = .white
    }
    
    func initViewModel(){
        viewModel.successfulRequest = {
            DispatchQueue.main.async {
                self.setupProductDeatilas()
                self.tableView.reloadData()
            }
        }
        
        viewModel.onErrorHandling = {
            DispatchQueue.main.async {
                self.view.makeToast(self.viewModel.message, duration: 1.0, position: .bottom)
            }
        }
        
        viewModel.successfulRequestSubmitReview = {
            DispatchQueue.main.async {
                self.closePopUPView()
                self.tableView.reloadData()
            }
        }
    }
}

extension ProductDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tell us what you think..." {
            textView.text = ""
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
        return textView.text.count + (newText.count - range.length) <= 140
    }
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNrOfReviews()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as? ReviewTableViewCell else  {
            return UITableViewCell()
        }
        
        if let review = viewModel.getReview(forRow: indexPath.row) {
            cell.setupReviewCell(review: review)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ratings & Reviews"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        returnedView.backgroundColor = .white

        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.text = "Ratings & Reviews"
        label.font = UIFont(name: "Arial Hebrew Bold", size: 20.0)
        label.textColor = .black
        returnedView.addSubview(label)

        return returnedView
    }
}
