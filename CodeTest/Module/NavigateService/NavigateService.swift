//
//  NavigateService.swift
//  CodeTest
//
//  Created by hech on 2023/11/25.
//

import Foundation
import GoogleMaps

enum NavigateStatus {
    case normal
    case navigating
}


class NavigateService {
    
    static let share = NavigateService()
    
    var startTime : Int = 0
    var endTime : Int = 0
    var totalDistance : Double = 0
    
    var status : NavigateStatus = .normal
    var path = GMSMutablePath()
    var locationArray = [CLLocationCoordinate2D]()
    
    
    func startNavigate() {
        if (status != .normal){
            return
        }
        status = .navigating
        startTime = Date.timeStamp
    }
    
    func endNavigate()  {
        if (status != .navigating){
            return
        }
        status = .normal
        endTime = Date.timeStamp
    }
    
    
    func addLocation(new : CLLocationCoordinate2D) {
        guard let last = locationArray.last else {
            locationArray.append(new)
            path.add(new)
            return
        }
        if (new.latitude == last.latitude && new.longitude == last.longitude){
            return
        }
        let location1 = CLLocation(latitude: last.latitude, longitude: last.longitude)
        let location2 = CLLocation(latitude: new.latitude, longitude: new.longitude)
        let distanceInMeters = location1.distance(from: location2)
        totalDistance += distanceInMeters
        locationArray.append(new)
        path.add(new)
    }
    
    
    func resetService()  {
        status = .normal
        startTime = 0
        endTime = 0
        totalDistance = 0
        locationArray.removeAll()
        path = GMSMutablePath()
    }
}
