//
//  GoogleModel.swift
//  CodeTest
//
//  Created by hech on 2023/11/24.
//

import Foundation
import HandyJSON


struct DirectionsModel: HandyJSON {
    var routes : [DirectionRoute]?
    var status : String?
}

struct DirectionRoute: HandyJSON {
    
    var bounds : DirectionBounds?
    var legs : [DirectionLegs]?
    var overview_polyline : DirectionPolyline?
}

struct DirectionBounds: HandyJSON {
    
    var northeast : DirectionLoction?
    var southwest : DirectionLoction?
}

struct DirectionLoction: HandyJSON {
    
    var lat : Double?
    var lng : Double?
}

struct DirectionLegs: HandyJSON {
    
    var distance : DirectionText?
    var lng : DirectionText?
    var end_address : String?
    var end_location : DirectionLoction?
    var start_address : String?
    var start_location : DirectionLoction?
    var steps : [DirectionSteps]?
    var polyline : DirectionPolyline?

    
}
struct DirectionText: HandyJSON {
    
    var text : String?
    var value : Int?
}

struct DirectionPolyline: HandyJSON {
    
    var points : String?
}

struct DirectionSteps: HandyJSON {
    var distance : DirectionText?
    var duration : DirectionText?
    var start_location : DirectionLoction?
    var end_location : DirectionLoction?
    var html_instructions : String?
    var travel_mode : String?

}
