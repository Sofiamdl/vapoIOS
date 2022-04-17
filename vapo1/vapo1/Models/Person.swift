//
//  Person.swift
//  vapo1
//
//  Created by sml on 04/04/22.
//

import Foundation


class CarStop {
    let peopleQuantity: Int
    let name: String
    let zone: String
    let district: String
    let street: String
    let number: String
    let extra: String
    
    init(peopleQuantity: Int, zone: String, name: String, district: String, street: String,  number: String, extra: String){
            self.peopleQuantity = peopleQuantity
            self.name = name
            self.zone = zone
        
        self.district = district
        self.street = street
        self.number = number
        self.extra = extra
        }
    
}
