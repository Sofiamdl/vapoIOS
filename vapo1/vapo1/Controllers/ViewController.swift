//
//  ViewController.swift
//  vapo1
//
//  Created by sml on 25/03/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var viewBelowCollection: UIView!
    @IBOutlet weak var popUp: UIView!
    
    @IBOutlet weak var layoutHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!

    @IBOutlet weak var carStopName: UITextField!
    @IBOutlet weak var zone: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var extra: UITextField!
    
    @IBOutlet weak var collection: UICollectionView!

    @IBOutlet weak var addressLabel: UILabel!
    var cards: [Card] = []

    var isAddress: Bool = false
    
    var finalAddress: Card!

    @IBAction func finishRegistration(_ sender: Any) {
        if (textFieldIsEmpty(carStopName) || textFieldIsEmpty(zone) || textFieldIsEmpty(district) || textFieldIsEmpty(street) || textFieldIsEmpty(number) || textFieldIsEmpty(extra)) {
            return
        } else if (isAddress == false) {
            cards.append(Card(image: "CarStopImage", carStop: carStopName.text! , zone: zone.text!, district: district.text!, street: street.text!,  number: number.text!, extra: extra.text!))
            if (cards.count != 1) {
                collectionHeight.constant += 111
                layoutHeight.constant += 111
                
            }
            popUp.isHidden = true;
            emptyAllTextFields()
            collection.reloadData()
        } else {
            finalAddress = Card(image: "CarStopImage", carStop: carStopName.text! , zone: zone.text!, district: district.text!, street: street.text!,  number: number.text!, extra: extra.text!)
            addressLabel.text = finalAddress.carStop
            addressLabel.textColor = UIColor.black
            popUp.isHidden = true;
            emptyAllTextFields()
        }
    }

    @IBAction func addressButton(_ sender: Any) {
        isAddress = true;
        popUp.isHidden = false;
    }

    @IBAction func openPopUp(_ sender: Any) {
        isAddress = false;
        popUp.isHidden = false;
    }

    func textFieldIsEmpty(_ textField: UITextField) -> Bool {
        
        let newTextField  = textField.text ?? ""
        if (newTextField == "" ) {
            return true
        } else {
            return false
        }
    }

    func emptyTextField(_ textField: UITextField) {
        textField.text = ""
    }

    func emptyAllTextFields() {
        emptyTextField(carStopName)
        emptyTextField(zone)
        emptyTextField(district)
        emptyTextField(street)
        emptyTextField(number)
        emptyTextField(extra)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // qntd celulas
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    //desenhar celulas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCell
        let card = cards[indexPath.row]
        cell.draw(card)
        return cell
    }
    
}


