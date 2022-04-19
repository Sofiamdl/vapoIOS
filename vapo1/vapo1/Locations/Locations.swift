//
//  Locations.swift
//  vapo1
//
//  Created by sml on 18/04/22.
//

import Foundation
import CoreLocation
import MapKit

class Locations {
    func distanceBetween(between firstAddress: String, and secondAddress: String, distanceCompletionHandler: @escaping (Double?, Error?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(firstAddress) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemarks = placemarks else {
                distanceCompletionHandler(nil, CalculateDistanceError.placemarksIsEmpty)
                return
            }
            let fromAddressStartPoint = placemarks[0]
            geocoder.geocodeAddressString(secondAddress, completionHandler: { (placemarks: [CLPlacemark]?, error: Error? ) in
                guard let placemarks = placemarks else {
                    distanceCompletionHandler(nil, CalculateDistanceError.placemarksIsEmpty)
                    return
                }
                let destinyAddressPoint = placemarks[0]
                self.distanceRoute(fromAddressStartPoint,
                                   to: destinyAddressPoint,
                                   distanceCompletionHandler)
            })
        }
    }
    
    func distanceRoute(_ fromAddressStartPoint: CLPlacemark,
                       to destinyAddressPoint: CLPlacemark,
                       _ distanceRouteCompletionHandler: @escaping (Double?, Error?) -> Void) {
        guard let startCoordinate = fromAddressStartPoint.location,
              let endCoordinate = destinyAddressPoint.location else {
                  distanceRouteCompletionHandler(nil, RouteDistanceError.destinyAddressPointIsNull)
                  return
              }
        
        let startMapPlacemark = MKPlacemark(coordinate: startCoordinate.coordinate)
        let endMapPlacemark = MKPlacemark(coordinate: endCoordinate.coordinate)
        
        let start = MKMapItem(placemark: startMapPlacemark)
        let end = MKMapItem(placemark: endMapPlacemark)
        
        let requestDistance: MKDirections.Request = MKDirections.Request()
        requestDistance.source = start
        requestDistance.destination = end
        requestDistance.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: requestDistance)
        directions.calculate(completionHandler: { (response: MKDirections.Response?, error: Error?) in
            guard let routes = response?.routes else {
                distanceRouteCompletionHandler(nil, RouteDistanceError.routesResponseIsEmpty)
                return
            }
            
            let distance: Double = routes[0].distance
            let distanceInKM: Double = distance / 1000.0
            distanceRouteCompletionHandler(distanceInKM, nil)
        })
    }
    
    func checkIfAddressExist(_ address: String,
                       _ checkAddressHandler: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemarks = placemarks else {
                checkAddressHandler(nil, CalculateDistanceError.placemarksIsEmpty)
                return
            }
            checkAddressHandler(placemarks.first?.location?.coordinate, nil)
        }
       
    }
}
