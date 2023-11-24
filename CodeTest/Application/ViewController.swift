//
//  ViewController.swift
//  CodeTest
//
//  Created by hech on 2023/11/23.
//

import UIKit
import GoogleMaps
class ViewController: UIViewController, GMSMapViewDelegate {

    private var mapView: GMSMapView!
    private var circle: GMSCircle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let options = GMSMapViewOptions()
//        options.camera = GMSCameraPosition(latitude: 1.285, longitude: 103.848, zoom: 12)
//        options.frame = self.view.bounds;
//
//        let mapView = GMSMapView(options:options)
//        self.view = mapView
        
     
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self
    }
    
    
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        print("mapViewDidStartTileRendering")

    }

    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
      print("mapViewDidFinishTileRendering")
    }
    
    
//    func drawPath() {
//        let origin = "San Francisco, CA"
//        let destination = "Mountain View, CA"
//
//        let directionsService = GMSServices.sharedServices().directionsService
//        let path = GMSMutablePath()
//
//        directionsService.route(fromPlace: origin, toPlace: destination) { (response, error) in
//            guard error == nil else {
//                print("Error getting directions: \(error!.localizedDescription)")
//                return
//            }
//
//            guard let route = response?.routes?.first else {
//                print("No routes found")
//                return
//            }
//
//            for step in route.steps {
//                for polyline in step.polyline.path {
//                    path.add(polyline.coordinate)
//                }
//            }
//
//            let polyline = GMSPolyline(path: path)
//            polyline.strokeWidth = 5.0
//            polyline.map = self.mapView
//        }
//    }
}

