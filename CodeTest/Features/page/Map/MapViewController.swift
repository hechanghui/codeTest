//
//  MapViewController.swift
//  CodeTest
//
//  Created by hech on 2023/11/24.
//

import UIKit
import GoogleMaps



class MapViewController: UIViewController {

  private let cameraLatitude: CLLocationDegrees = -33.868

  private let cameraLongitude: CLLocationDegrees = 151.2086

  private let cameraZoom: Float = 12

  lazy var mapView: GMSMapView = {
    let camera = GMSCameraPosition(
      latitude: cameraLatitude, longitude: cameraLongitude, zoom: cameraZoom)
    return GMSMapView(frame: .zero, camera: camera)
  }()

  var observation: NSKeyValueObservation?
  var location: CLLocation? {
    didSet {
      guard oldValue == nil, let firstLocation = location else { return }
      mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.delegate = self
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true
    view = mapView

    // Listen to the myLocation property of GMSMapView.
    observation = mapView.observe(\.myLocation, options: [.new]) {
      [weak self] mapView, _ in
      self?.location = mapView.myLocation
    }
  }

  deinit {
    observation?.invalidate()
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
    let alert = UIAlertController(
      title: "Location Tapped",
      message: "Current location: <\(location.latitude), \(location.longitude)>",
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
