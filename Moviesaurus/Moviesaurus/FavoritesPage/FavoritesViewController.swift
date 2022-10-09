//
//  FavoritesViewController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 31.07.2022.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    
    let defaultNumberOfItems = 0
    var favouriteManager = FavoriteManager()
    var favoriteMovies: [FavoriteMovie]? = [] {
        didSet {
            self.favoriteMoviesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("favorites", comment: "")
        favoriteMovies = favouriteManager.getAllFavoriteMovies()
        configureCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(
            self.reloadMyTable(notification:)), name: Notification.Name("reloadTable"),
                                               object: nil)
    }
    
    func configureCollectionView() {
        favoriteMoviesCollectionView.dataSource = self
        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    @objc func reloadMyTable(notification: Notification) {
        self.favoriteMovies = favouriteManager.getAllFavoriteMovies()
        self.favoriteMoviesCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
        self.favoriteMoviesCollectionView.reloadData()
    }
}

extension FavoritesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies?.count ?? defaultNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let favoriteMovie = favoriteMovies?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            cell.favoriteButton.tintColor = .red
            let movie = movieFromFavoriteMovie(favoriteMovie: favoriteMovie)
            cell.setupMovieCollectionViewCell(with: movie)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func movieFromFavoriteMovie(favoriteMovie: FavoriteMovie) -> Movie {
        return Movie(adult: nil, backdropPath: nil, genreIDS: nil, id: Int(favoriteMovie.id), originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: favoriteMovie.posterPath, releaseDate: favoriteMovie.releaseDate, title: favoriteMovie.title, video: nil, voteAverage: favoriteMovie.imdb, voteCount: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let favoriteMovie = favoriteMovies?[indexPath.row] {
            guard let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController else {
                return
            }
            let movieObjectFromFavoriteMovie = Movie(adult: nil, backdropPath: nil, genreIDS: nil, id: Int(favoriteMovie.id), originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: favoriteMovie.posterPath, releaseDate: favoriteMovie.releaseDate, title: favoriteMovie.title, video: nil, voteAverage: favoriteMovie.imdb, voteCount: nil)
            movieDetailViewController.movie = movieObjectFromFavoriteMovie
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }
}
