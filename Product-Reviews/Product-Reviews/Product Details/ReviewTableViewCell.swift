//
//  ReviewTableViewCell.swift
//  Product-Reviews
//
//  Created by Argjira Mala on 3/24/21.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var starOneImage: UIImageView!
    @IBOutlet weak var starTwoImage: UIImageView!
    @IBOutlet weak var starThreeImage: UIImageView!
    @IBOutlet weak var starFourImage: UIImageView!
    @IBOutlet weak var starFiveImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupReviewCell(review: Review){
        reviewLabel.text = review.text
        let rating: Rating = Rating(rawValue: review.rating) ?? Rating(rawValue: 1)!
        switch rating {
        case .one:
            starOneImage.image = UIImage(systemName: "star.fill")
        case .two:
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
        case .three:
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
        case .four:
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
            starFourImage.image = UIImage(systemName: "star.fill")
        case .five:
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
            starFourImage.image = UIImage(systemName: "star.fill")
            starFiveImage.image = UIImage(systemName: "star.fill")
        }
    }
}
