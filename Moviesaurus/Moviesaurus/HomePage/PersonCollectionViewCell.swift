//
//  PersonCollectionViewCell.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 25.08.2022.
//

import UIKit
import Kingfisher

class PersonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupPersonCell(person: PersonInSearch) {
        if let url = person.imageURL {
            let finalImageURL = NetworkConstants.baseURLOfPoster + url
            let url = URL(string: finalImageURL)
            personImageView.kf.setImage(with: url)
        } else {
            personImageView.image = UIImage(named: "personPlaceholder")
        }
        if let name = person.name {
            personNameLabel.text = name
        } else {
            personNameLabel.text = ConstantStrings.personNameNotFound
        }
    }
}
