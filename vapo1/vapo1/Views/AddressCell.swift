//
//  AddressCell.swift
//  vapo1
//
//  Created by sml on 19/04/22.
//

import UIKit

class AddressCell: UICollectionViewCell {
    @IBOutlet weak var carStop: UILabel!
    @IBOutlet weak var address: UILabel!
    
    func draw(_ card: Card) {
        carStop.text = card.carStop
        address.text = card.address
    }
}
