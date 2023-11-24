//
//  AppKeyConfig.swift
//
//
//  Created by  hech on 2021/1/12.
//
import UIKit

//google sdk key
enum GoogleSDKKey {
    static let apiKey = "AIzaSyB2uvfbfKqoo-wQwRvUe8MozGSeNwNJtMQ"
    static let mapsID = "70501440c9b56c78"
}


enum NetWorkConfig {
#if DEBUG
    static let hostUrl = "https://maps.googleapis.com/"
#else
    static let hostUrl = "https://maps.googleapis.com/"
#endif
}

