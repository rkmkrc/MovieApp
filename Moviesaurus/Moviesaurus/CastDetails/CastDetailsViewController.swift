//
//  CastDetailsViewController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 16.08.2022.
//

import Foundation
import UIKit
import Kingfisher

class CastDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castInfosView: UIView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var birthdateConstantLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var deathdayConstantLabel: UILabel!
    @IBOutlet weak var deathdateLabel: UILabel!
    @IBOutlet weak var placeOfBirthConstantLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var castMoviesCollectionView: UICollectionView! {
        didSet {
            castMoviesCollectionView.reloadData()
        }
    }
    var castMovies: [Movie]? = [] {
        didSet{
            castMoviesCollectionView.reloadData()
        }
    }
    @IBOutlet weak var bioLabel: UILabel!
    var person: Person?
    var personDetails: PersonDetails?
    var network = Network()
    let urlManager = UrlManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getCastDetails(personID: person?.id)
        getCastMovies(personID: person?.id)
    }
    
    func configureCollectionView() {
        castMoviesCollectionView.dataSource = self
        castMoviesCollectionView.delegate = self
        castMoviesCollectionView.register(UINib(nibName: "RecommendationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationsCollectionViewCell")
    }
    
    func configureCastDetailView(personDetails: PersonDetails?) {
        if let imageURL = person?.imageURL {
            let finalImageURL = NetworkConstants.baseURLOfPoster + imageURL
            let url = URL(string: finalImageURL)
            castImageView.kf.setImage(with: url)
        }
        if let name = personDetails?.name {
            castNameLabel.text = name
        } else {
            castNameLabel.text = ConstantStrings.personNameNotFound
        }
        if let birthdate = personDetails?.birthday {
            birthdateLabel.text = birthdate
        } else {
            birthdateLabel.text = ConstantStrings.birthdayNotFound
        }
        if let deathdate = personDetails?.deathday {
            deathdateLabel.text = deathdate
        } else {
            deathdateLabel.text = ConstantStrings.deathdayNotFound
        }
        if let placeOfBirth = personDetails?.placeOfBirth {
            placeOfBirthLabel.text = placeOfBirth
        } else {
            placeOfBirthLabel.text = ConstantStrings.placeOfBirthNotFound
        }
        if let biography = personDetails?.biography, personDetails?.biography != "" {
            bioLabel.text = biography
        } else {
            bioLabel.text = ConstantStrings.bioNotFound
        }
    }
    
    func getCastDetails(personID: Int?) {
        if let id = personID {
            urlManager.setup(path: NetworkConstants.personURL + "/" + String(describing: id))
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: PersonDetails.self) { result in
                switch result {
                case .success(let response):
                    self.configureCastDetailView(personDetails: response)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getCastMovies(personID: Int?) {
        if let id = personID {
            urlManager.setup(path: NetworkConstants.personURL + "/" + String(describing: id) + NetworkConstants.combinedCredits)
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: CastMovies.self) { result in
                switch result {
                case .success(let response):
                    self.castMovies = response.movies
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.castMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let movie = castMovies?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationsCollectionViewCell", for: indexPath) as! RecommendationsCollectionViewCell
            cell.setupRecommendationsCollectionViewCell(movie: movie)
            return cell
        }
        return UICollectionViewCell()
    }
}
