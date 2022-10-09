//
//  ViewController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 23.07.2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var popularMoviesCollectionView: UICollectionView!
    let network = Network()
    let favoriteManager = FavoriteManager()
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar = UISearchBar()
    var scopeButton = ""
    let urlManager = UrlManager()
    let defaultNumberOfItems = 0
    let widthConstant = 16.0
    let heightConstant = 4.0
    var queryItems = [
        NetworkConstants.apiKeyQueryItem,
        NetworkConstants.languageQueryItem
    ]
    var searchMovieQueryItems = [
        NetworkConstants.apiKeyQueryItem,
        NetworkConstants.languageQueryItem,
    ]
    var searchPersonQueryItems = [
        NetworkConstants.apiKeyQueryItem,
        NetworkConstants.languageQueryItem,
    ]
    var people: [PersonInSearch]? = [] {
        didSet {
            self.popularMoviesCollectionView.reloadData()
        }
    }
    var movies: [Movie]? = [] {
        didSet {
            self.popularMoviesCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ConstantStrings.popular
        network.page = 0
        configureCollectionView()
        initSearchController()
        loadMovies()
    }
    
    func initSearchController(){
        navigationItem.searchController = searchController
        searchBar = searchController.searchBar
        scopeButton = "Movie"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self;
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Movie","Person"]
    }
    
    func configureCollectionView() {
        popularMoviesCollectionView.dataSource = self
        popularMoviesCollectionView.delegate = self
        popularMoviesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        popularMoviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        popularMoviesCollectionView.register(UINib(nibName: "PersonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PersonCollectionViewCell")
    }
    func loadMovies(){
        urlManager.setup(path: NetworkConstants.popularMoviesURL)
        network.fetchData(urlString: self.urlManager.getUrl(), pagination: true, expecting: MovieCollection.self) { result in
            switch result {
            case .success(let response):
                if response.results != nil {
                    self.movies?.append(contentsOf: response.results ?? [])
                    self.network.totalPage = response.totalPages ?? self.network.totalPage
                    DispatchQueue.main.async {
                        self.popularMoviesCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputTextToBeSearched = searchController.searchBar.text else {
            return
        }
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scopeButton == "Movie" {
            searchMovieQueryItems.append(URLQueryItem(name: "query", value: inputTextToBeSearched))
            urlManager.setup(tempQueryItems: searchMovieQueryItems, path: NetworkConstants.searchMoviesURL)
            searchMovieQueryItems.removeLast()
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: MovieCollection.self) { result in
                switch result {
                case .success(let response):
                    if response.results != nil {
                        self.network.totalPage = response.totalPages ?? self.network.totalPage
                        self.movies? = response.results ?? []
                        DispatchQueue.main.async {
                            self.popularMoviesCollectionView.reloadData()
                            let indexPath:IndexPath = IndexPath(row:0, section:0) // to scroll to top
                            if self.movies?.count != 0 {
                                self.popularMoviesCollectionView.scrollToItem(at: indexPath, at:  UICollectionView.ScrollPosition.top, animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            searchPersonQueryItems.append(URLQueryItem(name: "query", value: inputTextToBeSearched))
            urlManager.setup(tempQueryItems: searchPersonQueryItems, path: NetworkConstants.searchPersonURL)
            searchPersonQueryItems.removeLast()
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: PersonCollection.self) { result in
                switch result {
                case .success(let response):
                    if response.results != nil {
                        self.network.totalPage = response.totalPages ?? self.network.totalPage
                        self.people? = response.results ?? []
                        self.popularMoviesCollectionView.reloadData()
                        let indexPath:IndexPath = IndexPath(row:0, section:0) // to scroll to top
                        if self.people?.count != 0 {
                            self.popularMoviesCollectionView.scrollToItem(at: indexPath, at:  UICollectionView.ScrollPosition.top, animated: true)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        urlManager.setup(path: NetworkConstants.popularMoviesURL)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // to show popular movies again
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scopeButton == "Person" {
            urlManager.setup(path: NetworkConstants.popularMoviesURL)
            self.people?.removeAll()
            searchBar.selectedScopeButtonIndex = 0
            popularMoviesCollectionView.reloadData()
        }
        self.network.page = 0   // to fetch popular movies from 1st page again
        network.fetchData(urlString: urlManager.getUrl(), pagination: true, expecting: MovieCollection.self) { result in
            switch result {
            case .success(let response):
                if response.results != nil {
                    self.movies?.removeAll() // to reset collection view elements
                    self.movies?.append(contentsOf: response.results ?? [])
                    self.network.totalPage = response.totalPages ?? self.network.totalPage
                    let indexPath:IndexPath = IndexPath(row:0, section:0) // to scroll to top
                    self.popularMoviesCollectionView.scrollToItem(at: indexPath, at:  UICollectionView.ScrollPosition.top, animated: true) // to scroll to top
                    self.popularMoviesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        popularMoviesCollectionView.reloadData()
    }
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scopeButton == "Movie" {
            return self.movies?.count ?? defaultNumberOfItems
        } else {
            return self.people?.count ?? defaultNumberOfItems
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scopeButton == "Movie" {
            if let movie = movies?[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
                cell.setupMovieCollectionViewCell(with: movie)
                if favoriteManager.isMovieInFavorites(movie: movie) {
                    cell.favoriteButton.tintColor = .red
                } else {
                    cell.favoriteButton.tintColor = .systemGray
                }
                return cell
            }
            return UICollectionViewCell()
        } else {
            if let person = people?[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as! PersonCollectionViewCell
                cell.setupPersonCell(person: person)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if position > (popularMoviesCollectionView.contentSize.height-scrollView.frame.size.height) {
            guard !network.isPaginating else {
                return // We are already fetching data
            }
            if scopeButton == "Movie" {
                network.fetchData(urlString: urlManager.getUrl(), pagination: true, expecting: MovieCollection.self) { result in
                    print(self.urlManager.getUrl())
                    switch result {
                    case .success(let response):
                        self.network.totalPage = response.totalPages ?? self.network.totalPage
                            self.movies?.append(contentsOf: response.results ?? [])
                            self.popularMoviesCollectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            } else {
                guard let inputTextToBeSearched = searchController.searchBar.text else {
                    return
                }
                searchPersonQueryItems.append(URLQueryItem(name: "query", value: inputTextToBeSearched))
                urlManager.setup(tempQueryItems: searchPersonQueryItems, path: NetworkConstants.searchPersonURL)
                searchPersonQueryItems.removeLast()
                
                network.fetchData(urlString: self.urlManager.getUrl(), pagination: true, expecting: PersonCollection.self) { result in
                    switch result {
                    case .success(let response):
                        self.network.totalPage = response.totalPages ?? self.network.totalPage
                        self.people?.append(contentsOf: response.results ?? [])
                        self.popularMoviesCollectionView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width-widthConstant, height: view.bounds.height / heightConstant)
    }
}
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        if scopeButton == "Movie" {
            guard let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController else {
                return
            }
            movieDetailViewController.movie = movies?[indexPath.row]
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        } else {
            guard let castDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: CastDetailsViewController.self)) as? CastDetailsViewController else {
                return
            }
            let person = Person(id: self.people?[indexPath.row].id, name: self.people?[indexPath.row].name, imageURL: self.people?[indexPath.row].imageURL, characterName: "")
            castDetailsViewController.person = person
            
            self.navigationController?.pushViewController(castDetailsViewController, animated: true)
        }
    }
}
