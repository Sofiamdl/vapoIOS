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
        
        carsCollection.dataSource = self
        carsCollection.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var routePopUp: UIView!
    @IBOutlet weak var carsCollection: UICollectionViewCar!
    
    @IBOutlet weak var viewBelowCollection: UIView!
    @IBOutlet weak var popUp: UIView!
    
    @IBOutlet weak var adressInfoAddress: UILabel!
    @IBOutlet weak var layoutHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!

    @IBOutlet weak var carStopName: UITextField!
    @IBOutlet weak var address: UITextField!

    
    @IBOutlet weak var collection: UICollectionView!

    @IBOutlet weak var addressLabel: UILabel!
    var cards: [Card] = []

    var route: [[Card]] = []

    @IBOutlet weak var backgroundView: UIView!
    var isAddress: Bool = false
    
    var finalAddress: Card!
        
    var location: Locations = Locations()

    @IBAction func finishRegistration(_ sender: Any) {
        if (textFieldIsEmpty(carStopName) || textFieldIsEmpty(address)) {
            return
        } else if (isAddress == false) {
            location.checkIfAddressExist(address.text!) { (coor, error) in
                if coor != nil {
                    self.cards.append(Card(image: "CarStopImage", carStop: self.carStopName.text! , address: self.address.text!))
                    if (self.cards.count != 1) {
                        self.collectionHeight.constant += 111
                        self.layoutHeight.constant += 111
                        
                    }
                    self.popUp.isHidden = true;
                    self.makeBackgroundViewDisappear()
                    self.emptyAllTextFields()
                    self.collection.reloadData()
                }
            }
        } else {
            location.checkIfAddressExist(address.text!) { (coor, error) in
                if coor != nil {
                    self.finalAddress = Card(image: "CarStopImage", carStop: self.carStopName.text! , address: self.address.text!)
                    self.addressLabel.text = self.finalAddress.carStop
                    self.adressInfoAddress.text = self.finalAddress.address
                    self.addressLabel.textColor = UIColor.black
                    self.popUp.isHidden = true;
                    self.makeBackgroundViewDisappear()
                    self.emptyAllTextFields()
                }
            }

        }
    }

  
    @IBAction func addressButton(_ sender: Any) {
        isAddress = true;
        popUp.isHidden = false;
        makeBackgroundViewAppear()
    }

    @IBAction func openPopUp(_ sender: Any) {
        isAddress = false;
        popUp.isHidden = false;
        makeBackgroundViewAppear()
    }

    @IBAction func calculateRoutes(_ sender: UIButton) {
        makeArrayOfDistances() { (distancesGraph, distancesFinalAddress) in
            self.routeAlgorithm(distancesGraph, distancesFinalAddress)
//            print(self.carStopsArray)
            self.carsCollection.reloadData()
            self.makeBackgroundViewAppear()
            self.routePopUp.isHidden = false
            
                   }
    }
    
    @IBAction func recalculate(_ sender: UIButton) {
        self.routePopUp.isHidden = true
        makeBackgroundViewDisappear()
        carStopsArray = []
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
        emptyTextField(address)
    }
    
    func makeArrayOfDistances(completion:@escaping((([[Double]],[Double])) -> ())) {
        var distancesGraph: [[Double]] = []
        var distancesFinalAddress : [Double] = []
        let group = DispatchGroup()

        for mainAddressIndex in 0..<cards.count {
            distancesGraph.append([])
            distancesFinalAddress.append(0)
            for i in 0..<cards.count {
                distancesGraph[mainAddressIndex].append(0.0)
                group.enter()
                location.distanceBetween(between: cards[mainAddressIndex].address, and: cards[i].address) { (coor, error) in
                        distancesGraph[mainAddressIndex][i] = (coor!)
                    group.leave()
                    }
            }
            group.enter()
            location.distanceBetween(between: cards[mainAddressIndex].address, and: finalAddress.address) { (coor, error) in
                    distancesFinalAddress[mainAddressIndex] = (coor!)
                group.leave()
                }
        }
        group.notify(queue: .main, execute: {
            completion((distancesGraph, distancesFinalAddress))
            })
    }
    
//    var carStopsArray: [Car] = [Car(stops:[Card(image: "CarStopImage", carStop: "fodase" , address: "fodase"), Card(image: "CarStopImage", carStop: "fodase" , address: "fodase"), Card(image: "CarStopImage", carStop: "fodase" , address: "fodase")], title: "fodase"), ]
    var carStopsArray: [Car] = []
    
    func routeAlgorithm(_ distancesGraph:[[Double]],_ distancesFinalAddress:[Double]) -> [[Card]] {
        var finalRoute: [[Card]] = []
        var cardsDuplicate = cards
        var distancesFinalAddressDuplicate = distancesFinalAddress
        var distancesGraphDuplicate = distancesGraph
        var addressCounter: Int = 1
        var distancesFromAddress: [Double] = []
//        print("first", distancesFinalAddress, distancesGraphDuplicate)
        while distancesFinalAddressDuplicate.count > 0 {
            if addressCounter == 1 {
                (distancesFromAddress) = removeCardsAndDistancesOfFirstAddress(distancesFinalAddressDuplicate: &distancesFinalAddressDuplicate, distancesGraphDuplicate: &distancesGraphDuplicate, finalRoute: &finalRoute, cardsDuplicate: &cardsDuplicate)
                addressCounter += 1
            } else if addressCounter == 2 || addressCounter == 3 {
                    (distancesFromAddress) = removeCardsAndDistancesOfSecondeAndThirdAddress(distancesFinalAddressDuplicate: &distancesFinalAddressDuplicate, distancesGraphDuplicate: &distancesGraphDuplicate, finalRoute: &finalRoute, cardsDuplicate: &cardsDuplicate, distancesFromAddress: distancesFromAddress)
                if distancesFinalAddressDuplicate.count == 2 {
                    addressCounter = 1
                } else {
                    addressCounter += 1
                }
            } else {
                    (distancesFromAddress) = removeCardsAndDistancesOfSecondeAndThirdAddress(distancesFinalAddressDuplicate: &distancesFinalAddressDuplicate, distancesGraphDuplicate: &distancesGraphDuplicate, finalRoute: &finalRoute, cardsDuplicate: &cardsDuplicate, distancesFromAddress: distancesFromAddress)
                    addressCounter = 1
                
            }
//            print(addressCounter, distancesFromAddress)
//            print(addressCounter, distancesFinalAddressDuplicate)
//            print(addressCounter, distancesGraphDuplicate)
//            print(addressCounter, cardsDuplicate)


        }
        
        for i in 0..<finalRoute.count {
            carStopsArray.append(Car(stops: finalRoute[i], title: "Carro " + String(i+1)))
        }
        return finalRoute
    }
    
    func indexOfBiggerElement(_ array:[Double]) -> Int {
        for i in 0..<array.count {
            if array[i] == array.max() {
                return i
            }
        }
        return 0
    }
    
    func indexOfSmallerElement(_ array:[Double]) -> Int {
        for i in 0..<array.count {
            if array[i] == array.min() {
                return i
            }
        }
        return 0
    }

    func removeElementFromEachArray(index: Int, array: inout [[Double]]) {
        for i in 0..<array.count {
            array[i].remove(at: index)
        }
    }
    
    func removeCardsAndDistancesOfFirstAddress(distancesFinalAddressDuplicate: inout [Double], distancesGraphDuplicate: inout [[Double]], finalRoute: inout [[Card]], cardsDuplicate: inout [Card]) -> ([Double]) {
        let indexOfBiggerDistance = indexOfBiggerElement(distancesFinalAddressDuplicate)
        distancesFinalAddressDuplicate.remove(at: indexOfBiggerDistance)
        removeElementFromEachArray(index: indexOfBiggerDistance, array: &distancesGraphDuplicate)
        finalRoute.append([cardsDuplicate.remove(at: indexOfBiggerDistance)])
        let distancesFromFirstAddress :[Double] = distancesGraphDuplicate.remove(at: indexOfBiggerDistance)
        return (distancesFromFirstAddress)
    }
    
    func removeCardsAndDistancesOfSecondeAndThirdAddress(distancesFinalAddressDuplicate: inout [Double], distancesGraphDuplicate: inout [[Double]], finalRoute: inout [[Card]], cardsDuplicate: inout [Card], distancesFromAddress: [Double]) -> ([Double]) {
        let indexOfSmallerDistance = indexOfSmallerElement(distancesFromAddress)
        distancesFinalAddressDuplicate.remove(at: indexOfSmallerDistance)
        removeElementFromEachArray(index: indexOfSmallerDistance, array: &distancesGraphDuplicate)
        finalRoute[finalRoute.count-1].append(cardsDuplicate.remove(at: indexOfSmallerDistance))
        let distancesFromAddress :[Double] = distancesGraphDuplicate.remove(at: indexOfSmallerDistance)
        return distancesFromAddress
    }
    
    func makeBackgroundViewAppear() {
        backgroundView.backgroundColor = UIColor(white:0, alpha: 0.5)
        backgroundView.isHidden = false
    }
    
    func makeBackgroundViewDisappear() {
        backgroundView.isHidden = true
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // qntd celulas
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.carsCollection {
            return carStopsArray.count
        } else {
            return cards.count
        }
    }
    
    //desenhar celulas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.carsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Car", for: indexPath) as! CarCell
            let card = carStopsArray[indexPath.row]
            cell.draw(card)
            cell.collection.delegate = cell
            cell.collection.dataSource = cell
            return cell

            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as! CardCell
                let card = cards[indexPath.row]
                cell.draw(card)
                return cell
            }
    }
    
}


