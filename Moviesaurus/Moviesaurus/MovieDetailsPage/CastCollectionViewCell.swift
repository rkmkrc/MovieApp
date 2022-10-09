//
//  CastCollectionViewCell.swift
//  Moviesaurus
//
//  Created by Erkam Karaca on 5.08.2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var personCharacterLabel: UILabel!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCastCollectionViewCell(person: Person?) {
        if let personName = person?.name {
            self.personNameLabel.text = personName
        }
        if let personCharacterName = person?.characterName {
            self.personCharacterLabel.text = personCharacterName
        }
        if person?.imageURL == "" || person?.imageURL == nil {
            personImageView.image = UIImage(named: "personPlaceholder")
        } else {
            let finalImageURL = NetworkConstants.baseURLOfPoster + (person?.imageURL ?? "")
            let url = URL(string: finalImageURL)
            personImageView.kf.setImage(with: url)
        }
    }
}
