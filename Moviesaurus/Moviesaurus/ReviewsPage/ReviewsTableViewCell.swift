//
//  ReviewsTableViewCell.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 18.08.2022.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureReviewsTableViewCell(review: Review) {
        if let avatarPath = review.authorDetails?.avatarPath {
            let finalImageURL = NetworkConstants.baseURLOfPoster + avatarPath
            let url = URL(string: finalImageURL)
            avatarImageView.kf.setImage(with: url)
        }
        if review.authorDetails?.avatarPath == nil || review.authorDetails?.avatarPath == "" {
            avatarImageView.image = UIImage(named: "personPlaceholder")
        }
        if let username = review.authorDetails?.username {
            usernameLabel.text = username
        } else {
            usernameLabel.text = ConstantStrings.usernameNotFound
        }
        if let date = review.creationDate {
            dateLabel.text = trimDate(date: date)
        } else {
            dateLabel.text = ConstantStrings.dateNotFound
        }
        if let comment = review.content {
            commentLabel.text = comment
        } else {
            commentLabel.text = ConstantStrings.commentNotFound
        }
        if let rating = review.authorDetails?.rating {
            ratingLabel.text = String(describing: rating)
        } else {
            ratingLabel.text = ConstantStrings.ratingNotFound
        }
    }
    
    func trimDate(date: String) -> String {
        let endOfSentence = date.firstIndex(of: "T")!
        let firstSentence = date[..<endOfSentence]
        return String(describing: firstSentence)
    }
}
