
//
//  MovieDetailViewController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 29.07.2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var posterImagesContainerView: UIView!
    @IBOutlet weak var releaseDateConstantLabel: UILabel!
    @IBOutlet weak var genreConstantLabel: UILabel!
    @IBOutlet weak var budgetConstantLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var revenueConstantLabel: UILabel!
    @IBOutlet weak var durationConstantLabel: UILabel!
    @IBOutlet weak var productionCompaniesConstantLabel: UILabel!
    @IBOutlet weak var originalTitleConstantLabel: UILabel!
    @IBOutlet weak var homePageLinkConstantLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var homepageLinkTextView: UITextView!
    @IBOutlet weak var overviewConstantLabel: UILabel!
    @IBOutlet weak var castConstantLabel: UILabel!
    @IBOutlet weak var recommendationsConstantLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var productionCompaniesLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    @IBOutlet weak var foregroundPosterImageView: UIImageView!
    @IBOutlet weak var movieDetailsContainerView: UIView!
    @IBOutlet weak var overviewContainerView: UIView!
    @IBOutlet weak var seeReviewsButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton! {
        didSet{
            if let movieToBeSearched = movie {
                if favoriteManager.isMovieInFavorites(movie: movieToBeSearched) {
                    favouriteButton.tintColor = .red
                } else {
                    favouriteButton.tintColor = .systemGray
                }
            }
        }
    }
    
    let numberOfItems = 0
    var movie: Movie? = nil
    var dummyMovie = Movie(adult: nil, backdropPath: nil, genreIDS: nil, id: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, releaseDate: nil, title: nil, video: nil, voteAverage: nil, voteCount: nil)
    let cornerRadius = 20.0
    var movieElement: MovieDetails? = nil
    var favoriteManager = FavoriteManager()
    let network = Network()
    var genres: [Genre]? = []
    var productionCompanies: [ProductionCompany]? = []
    let urlManager = UrlManager()
    var peopleOfCast: [Person]? = [] {
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    var recommendedMovies: [Movie]? = [] {
        didSet {
            self.recommendationsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewsAppearance()
        setupLocalization()
        setupMoviePosterImage()
        blurImage(imageView: backgroundPosterImageView)
        getMovieDetails(movie: movie)
        getMovieCredits()
        getRecommendedMovies()
        configureCollectionViews()
    }
    
    @IBAction func seeReviewsButtonTapped(_ sender: UIButton) {
        guard let reviewsPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: ReviewsPageViewController.self)) as? ReviewsPageViewController else {
            return
        }
        reviewsPageViewController.movie = movie
        self.navigationController?.pushViewController(reviewsPageViewController, animated: true)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
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
    
    func configureCollectionViews() {
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        recommendationsCollectionView.register(UINib(nibName: "RecommendationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationsCollectionViewCell")
    }
    
    func setupMoviePosterImage() {
        if movie?.posterPath != "" {
            let finalImageURL = (NetworkConstants.baseURLOfPoster + (movie?.posterPath ?? ""))
            let url = URL(string: finalImageURL)
            backgroundPosterImageView.kf.setImage(with: url)
            foregroundPosterImageView.kf.setImage(with: url)
        } else {
            backgroundPosterImageView.image = UIImage(named: "moviePosterPlaceholder")
            foregroundPosterImageView.image = UIImage(named: "moviePosterPlaceholder")
        }
        backgroundPosterImageView.layer.cornerRadius = cornerRadius
        posterImagesContainerView.layer.cornerRadius = cornerRadius
    }
    
    func customizeViewsAppearance(){
        movieDetailsContainerView.layer.cornerRadius = 20
        movieDetailsContainerView.layer.borderWidth = 0.1
        overviewContainerView.layer.cornerRadius = 20
        overviewContainerView.layer.borderWidth = 0.1
    }
    
    func blurImage(imageView: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    func configureView(response: MovieDetails) {
        homepageLinkTextView.isScrollEnabled = false
        movieNameLabel.text = movie?.title
        if let releaseDate = response.releaseDate, response.releaseDate != "" {
            releaseDateLabel.text = String(describing: releaseDate)
        } else {
            releaseDateLabel.text = ConstantStrings.releaseDateNotFound
        }
        if let duration = response.runtime, response.runtime != 0 {
            durationLabel.text = String(describing: duration) + " \(ConstantStrings.minutes)"
        } else {
            durationLabel.text = ConstantStrings.durationNotFound
        }
        if let revenue = response.revenue, response.revenue != 0 {
            revenueLabel.text = String(describing: revenue)
        } else {
            revenueLabel.text = ConstantStrings.revenueNotFound
        }
        if let budget = response.budget, response.budget != 0 {
            budgetLabel.text = String(describing: budget)
        } else {
            budgetLabel.text = ConstantStrings.budgetNotFound
        }
        if let genres = response.genres {
            setGenresLabel(genres: genres)
        }  else {
            genreLabel.text = ConstantStrings.genreNotFound
        }
        if let rating = movie?.voteAverage, response.imdb != 0 {
            imdbLabel.text = String(describing: rating)
        } else {
            imdbLabel.text = ConstantStrings.imdbNotFound
        }
        if let originalTitle = response.originalTitle, response.originalTitle != "" {
            originalTitleLabel.text = originalTitle
        } else {
            originalTitleLabel.text = ConstantStrings.originalTitleNotFound
        }
        if let homePageLink = response.homePageLink, response.homePageLink != "" {
            homepageLinkTextView.text = homePageLink
        } else {
            homepageLinkTextView.text = ConstantStrings.homepageNotFound
        }
        if let overview = response.overview, response.overview != "" {
            movieOverviewLabel.text = overview
        } else {
            movieOverviewLabel.text = ConstantStrings.overviewNotFound
        }
        if let productionCompaniesFromResponse = response.productionCompanies {
            setProductionCompaniesLabel(productionCompanies: productionCompaniesFromResponse)
        }
    }
    
    func setProductionCompaniesLabel(productionCompanies: [ProductionCompany]) {
        self.productionCompanies = productionCompanies
        let productionCompaniesString = productionCompanies.compactMap({ $0.name }).joined(separator: ", ")
        if productionCompaniesString == "" {
            productionCompaniesLabel.text = NSLocalizedString("productionCompaniesNotFound", comment: "")
        } else {
            productionCompaniesLabel.text = productionCompaniesString
        }
    }
    
    func setGenresLabel(genres: [Genre]) {
        self.genres = genres
        let genresString = genres.compactMap({ $0.name }).joined(separator: ", ")
        if genresString != "" {
            genreLabel.text = genresString
        } else {
            genreLabel.text = ConstantStrings.genreNotFound
        }
    }
    
    func setPlaceholders(releaseDate: String?, budget: Int?, revenue: Int?, duration: Int?, imdb: Double?, overview: String?, originalTitle: String?, homepageLink: String?) {
        if releaseDate == "" {
            releaseDateLabel.text = NSLocalizedString("dateNotFound", comment: "")
        }
        if budget == 0 {
            budgetLabel.text = NSLocalizedString("budgetNotFound", comment: "")
        }
        if revenue == 0 {
            revenueLabel.text = NSLocalizedString("revenueNotFound", comment: "")
        }
        if duration == 0 {
            durationLabel.text = NSLocalizedString("durationNotFound", comment: "")
        }
        if imdb == 0.0 {
            imdbLabel.text = NSLocalizedString("imdbNotFound", comment: "")
        }
        if overview == "" {
            movieOverviewLabel.text = NSLocalizedString("overviewNotFound", comment: "")
        }
        if originalTitle == "" {
            originalTitleLabel.text = NSLocalizedString("originalTitleNotFound", comment: "")
        }
        if homepageLink == "" {
            homepageLinkTextView.text = NSLocalizedString("homepageNotFound", comment: "")
        }
    }
    
    func getMovieDetails(movie: Movie?) {
        if let id = movie?.id {
            urlManager.setup(path: NetworkConstants.getMovieURL + "/" + String(describing: id))
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: MovieDetails.self) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.configureView(response: response)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getMovieCredits() {
        if let movieID = movie?.id {
            urlManager.setup(path: NetworkConstants.getMovieURL + "/" + String(describing: movieID) + NetworkConstants.getMovieCreditsURL)
            network.fetchData(urlString: urlManager.getUrl(), expecting: Credit.self) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.peopleOfCast = response.cast
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getRecommendedMovies() {
        if let movieID = movie?.id {
            urlManager.setup(path: NetworkConstants.getMovieURL + "/" + String(describing: movieID) + NetworkConstants.getRecommendationsURL)
            network.fetchData(urlString: urlManager.getUrl(), pagination: true, expecting: MovieCollection.self) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.recommendedMovies = response.results
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension MovieDetailViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return peopleOfCast?.count ?? numberOfItems
        } else if collectionView == recommendationsCollectionView {
            return recommendedMovies?.count ?? numberOfItems
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            if let person = peopleOfCast?[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
                cell.setupCastCollectionViewCell(person: person)
                return cell
            }
        } else if collectionView == recommendationsCollectionView {
            if let recommendedMovie = recommendedMovies?[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationsCollectionViewCell", for: indexPath) as! RecommendationsCollectionViewCell
                cell.setupRecommendationsCollectionViewCell(movie: recommendedMovie)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView {
            if let person = peopleOfCast?[indexPath.row]{
                guard let castDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: CastDetailsViewController.self)) as? CastDetailsViewController else {
                    return
                }
                castDetailViewController.person = person
                self.navigationController?.pushViewController(castDetailViewController, animated: true)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == recommendationsCollectionView {
            let position = scrollView.contentOffset.x
            if position > (recommendationsCollectionView.contentSize.width-scrollView.frame.size.width) {
                guard !network.isPaginating else {
                    return // We are already fetching data
                }
                if let movieID = movie?.id {
                    urlManager.setup(path: NetworkConstants.getMovieURL + "/" + String(describing: movieID) + NetworkConstants.getRecommendationsURL)
                    network.fetchData(urlString: urlManager.getUrl(), pagination: true, expecting: MovieCollection.self) { result in
                        switch result {
                        case .success(let response):
                            self.recommendedMovies?.removeLast()
                            // avoid last element to appear twice
                            self.recommendedMovies?.append(contentsOf: response.results ?? [])
                            DispatchQueue.main.async {
                                self.recommendationsCollectionView.reloadData()
                            }
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        }
    }
    
    func setupLocalization() {
        releaseDateConstantLabel.text = ConstantStrings.releaseDate
        genreConstantLabel.text = ConstantStrings.genre
        budgetConstantLabel.text = ConstantStrings.budget
        revenueConstantLabel.text = ConstantStrings.revenue
        durationConstantLabel.text = ConstantStrings.duration
        productionCompaniesConstantLabel
            .text = ConstantStrings.productionCompanies
        originalTitleConstantLabel.text = ConstantStrings.originalTitle
        homePageLinkConstantLabel.text = ConstantStrings.homepage
        overviewConstantLabel.text = ConstantStrings.overview
        castConstantLabel.text = ConstantStrings.cast
        recommendationsConstantLabel.text = ConstantStrings.recommendations
    }
}
