//
//  HeroCollectionViewCell.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 28/10/23.
//

import UIKit
import Kingfisher

class HeroCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "HeroCollectionViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var view : UIView!
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        photo.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cómo poner una tarjetita bonita
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.blue.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
    }
    func updateView(
        name: String? = nil,
        photo: String? = nil
    ){
        self.name.text = name
        self.photo.kf.setImage(with: URL(string: photo ?? ""))
    }
}
