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
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var extra: UITextField!
    
    @IBOutlet weak var collection: UICollectionView!

    @IBOutlet weak var addressLabel: UILabel!
    var cards: [Card] = []

    var isAddress: Bool = false
    
    var finalAddress: Card!
    
    var location: Locations = Locations()

    @IBAction func finishRegistration(_ sender: Any) {
        if (textFieldIsEmpty(carStopName) || textFieldIsEmpty(city) || textFieldIsEmpty(district) || textFieldIsEmpty(street) || textFieldIsEmpty(number) || textFieldIsEmpty(extra)) {
            return
        } else if (isAddress == false) {
            location.checkIfAddressExist(carStopName.text!) { (coor, error) in
                if coor != nil {
                    self.cards.append(Card(image: "CarStopImage", carStop: self.carStopName.text! , city: self.city.text!, district: self.district.text!, street: self.street.text!,  number: self.number.text!, extra: self.extra.text!))
                    if (self.cards.count != 1) {
                        self.collectionHeight.constant += 111
                        self.layoutHeight.constant += 111
                        
                    }
                    self.popUp.isHidden = true;
                    self.emptyAllTextFields()
                    self.collection.reloadData()
                }
            }
        } else {
            location.checkIfAddressExist(carStopName.text!) { (coor, error) in
                if coor != nil {
                    self.finalAddress = Card(image: "CarStopImage", carStop: self.carStopName.text! , city: self.city.text!, district: self.district.text!, street: self.street.text!,  number: self.number.text!, extra: self.extra.text!)
                    self.addressLabel.text = self.finalAddress.carStop
                    self.addressLabel.textColor = UIColor.black
                    self.popUp.isHidden = true;
                    self.emptyAllTextFields()
                }
            }
//            location.distanceBetween(between: finalAddress.carStop, and: cards[0].carStop) { (coor, error) in
//               print(coor!)
//            }
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

    @IBAction func CLICK(_ sender: UIButton) {
        print(makeArrayOfDistances())
    }
    func emptyAllTextFields() {
        emptyTextField(carStopName)
        emptyTextField(city)
        emptyTextField(district)
        emptyTextField(street)
        emptyTextField(number)
        emptyTextField(extra)
    }
    
    func makeArrayOfDistances() -> [[Double]] {
        var addressGraph: [[Double]] = []
        let group = DispatchGroup()

        for mainAddressIndex in 0..<cards.count {
            addressGraph.append([])
            for i in 0..<cards.count {
                addressGraph[mainAddressIndex].append(0.0)
                group.enter()
                location.distanceBetween(between: cards[mainAddressIndex].carStop, and: cards[i].carStop) { (coor, error) in
                        addressGraph[mainAddressIndex][i] = (coor!)
                    group.leave()
                    }
                
            }
        }
        return(addressGraph)
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


