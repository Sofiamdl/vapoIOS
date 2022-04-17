//
//  CardCell.swift
//  vapo1
//
//  Created by sml on 05/04/22.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var carStop: UILabel!
    
    func draw(_ card: Card) {
        carStop.text = card.carStop
        image.image = UIImage(named: card.image)
        image.layer.cornerRadius = 30
    }
}
