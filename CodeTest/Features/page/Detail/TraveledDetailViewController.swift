//
//  TraveledDetailViewController.swift
//  CodeTest
//
//  Created by hech on 2023/11/25.
//

import UIKit
import GoogleMaps

class TraveledDetailViewController: BaseViewController, GMSMapViewDelegate {

    private let cameraLatitude: CLLocationDegrees = -0
    private let cameraLongitude: CLLocationDegrees = 0
    private let cameraZoom: Float = 14
    private var observation: NSKeyValueObservation?

    
    private var distanceLabel : CommonLabel!
    private var timeLabel: CommonLabel!
    
    lazy var mapView: GMSMapView = {
        let options = GMSMapViewOptions()
        let camera = GMSCameraPosition(
            latitude: cameraLatitude, longitude: cameraLongitude, zoom: cameraZoom)
        options.frame = self.view.bounds;
        return GMSMapView(options:options)
    }()
    
    private var location: CLLocation? {
        didSet {
            guard oldValue == nil, let firstLocation = location else { return }
            mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: cameraZoom)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        drawUserPath()
    }
    
    
    func setupView(){
        self.title = "行程摘要"
        distanceLabel = CommonLabel.init()
        self.view.addSubview(distanceLabel)
        distanceLabel.text = String(format: "行进总距离：%.1f米", NavigateService.share.totalDistance)
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(2)
            make.left.equalTo(12)
            make.height.equalTo(18)
        }
        
        timeLabel = CommonLabel.init()
        let time = NavigateService.share.endTime - NavigateService.share.startTime
      
        self.view.addSubview(timeLabel)
        timeLabel.text = String(format: "总用时：%ldm : %02lds", time/60, time%60)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(2)
            make.left.equalTo(12)
            make.height.equalTo(18)
        }
        observation = mapView.observe(\.myLocation, options: [.new]) {
            [weak self] mapView, _ in
            self?.location = mapView.myLocation
        }
        mapView.delegate = self
//        mapView.settings.compassButton = true
//        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    
    func drawUserPath() {

//        let userPolyline?.map = nil
        let path = NavigateService.share.path
        let userPolyline = GMSPolyline(path: path)
        userPolyline.strokeWidth = 3.0
        userPolyline.strokeColor = .green
        userPolyline.map = self.mapView
    }
}
