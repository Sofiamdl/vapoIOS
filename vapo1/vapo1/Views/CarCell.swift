//
//  CarCell.swift
//  vapo1
//
//  Created by sml on 19/04/22.
//

import UIKit

class CarCell: UICollectionViewCell {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        collection.dataSource = self
//        collection.delegate = self
//        // Do any additional setup after loading the view.
//    }
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    var address: [Card] = []
    func draw(_ car: Car){
        title.text = car.title
        address = car.stops
        collectionHeight.constant += 77
    }
}

extension CarCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // qntd celulas
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return address.count
    }
    
    //desenhar celulas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Address", for: indexPath) as! AddressCell
        let card = address[indexPath.row]
        cell.draw(card)
        return cell
    }
    
}
