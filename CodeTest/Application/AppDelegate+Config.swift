//
//  AppDelegate+Config.swift
//   
//
//  Created by  hech on 2021/1/15.
//

import UIKit
import GoogleMaps
import GooglePlaces

extension AppDelegate {
  
    //
    func config(){
        GMSServices.provideAPIKey(GoogleSDKKey.apiKey)
        GMSPlacesClient.provideAPIKey(GoogleSDKKey.apiKey)
    }
    

    
}
