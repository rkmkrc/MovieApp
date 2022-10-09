//
//  ReviewsPageViewController.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 17.08.2022.
//

import Foundation
import UIKit

class ReviewsPageViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var reviewsTableView: UITableView! {
        didSet {
            reviewsTableView.dataSource = self
            self.reviewsTableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
        }
    }
    var movie: Movie?
    var network = Network()
    let urlManager = UrlManager()
    var reviews: [Review]? = [] {
        didSet{
            reviewsTableView.reloadData()     
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviews()
    }
    
    func getReviews() {
        if let movieID = movie?.id {
            urlManager.setup(path: NetworkConstants.getMovieURL + "/" + String(describing: movieID) + NetworkConstants.reviewsURL)
            network.fetchData(urlString: urlManager.getUrl(), pagination: false, expecting: ReviewCollection.self) { result in
                switch result {
                case .success(let response):
                    self.reviews = response.reviews
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let review = reviews?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
            cell.configureReviewsTableViewCell(review: review)
            return cell
        }
        return UITableViewCell()
    }
}
