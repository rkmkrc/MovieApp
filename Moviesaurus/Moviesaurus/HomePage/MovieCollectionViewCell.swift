//
//  MovieCollectionViewCell.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 27.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var releaseDateConstantLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView! {
        didSet {
            moviePosterImageView.layer.cornerRadius = imageCornerRadius
        }
    }
    
    var movie: Movie?
    var favoriteManager = FavoriteManager()
    var dummyMovie = Movie(adult: nil, backdropPath: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
    var favMovIDS: [Int] = []
    let imageCornerRadius = 10.0
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutSubviews()
        self.layer.cornerRadius = imageCornerRadius
    }
    
    @IBAction func tapOnFavoriteButton(_ sender: UIButton) {
        if !favoriteManager.isMovieInFavorites(movie: movie ?? dummyMovie) {
            favoriteManager.addToFavorites(movie: movie)
            sender.tintColor = .red
        } else {
            if let movieToBeDeleted = movie {
                favoriteManager.deleteFromFavorites(movie: movieToBeDeleted)
                NotificationCenter.default.post(name: Notification.Name("reloadTable"), object: nil)
            }
            sender.tintColor = .systemGray
        }
    }
    
    func setupMovieCollectionViewCell(with movie: Movie){
        self.movie = movie
        movieTitleLabel.text = movie.title
        releaseDateConstantLabel.text = NSLocalizedString("releaseDate", comment: "")
        releaseDateLabel.text = movie.releaseDate
        if let imdbRating = movie.voteAverage {
            imdbLabel.text = String(describing: imdbRating)
        }
        let finalImageURL = NetworkConstants.baseURLOfPoster + (movie.posterPath ?? "")
        let url = URL(string: finalImageURL)
        moviePosterImageView.kf.setImage(with: url)
        setPlaceholders(movie: movie)
    }
    
    func setupForPerson(person: PersonInSearch?) {
        let finalImageURL = NetworkConstants.baseURLOfPoster + (person?.imageURL ?? "")
        let url = URL(string: finalImageURL)
        moviePosterImageView.kf.setImage(with: url)
        movieTitleLabel.text = person?.name
        releaseDateLabel.text = String(describing: person?.id)
    }
    
    func setPlaceholders(movie: Movie){
        if movie.title == nil || movie.title == "" {
            movieTitleLabel.text = NSLocalizedString("movieNameNotFound", comment: "")
        }
        if movie.releaseDate == nil || movie.releaseDate == "" {
            releaseDateLabel.text = NSLocalizedString("dateNotFound", comment: "")
        }
        if movie.voteAverage == nil || movie.voteAverage == 0.0 {
            imdbLabel.text = NSLocalizedString("imdbNotFound", comment: "")
        }
        if movie.posterPath == nil || movie.posterPath == "" {
            moviePosterImageView.image = UIImage(named: "moviePosterPlaceholder")
        }
    }
}
