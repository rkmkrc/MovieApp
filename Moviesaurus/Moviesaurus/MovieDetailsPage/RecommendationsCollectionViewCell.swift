//
//  RecommendationsCollectionViewCell.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 7.08.2022.
//

import UIKit

class RecommendationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupRecommendationsCollectionViewCell(movie: Movie?) {
        if movie?.posterPath == "" || movie?.posterPath == nil {
            moviePosterImageView.image = UIImage(named: "moviePosterPlaceholder")
        } else {
            let finalImageURL = NetworkConstants.baseURLOfPoster + (movie?.posterPath ?? "")
            let url = URL(string: finalImageURL)
            moviePosterImageView.kf.setImage(with: url)
        }
    }
}
