//
//  MapViewController.swift
//  CodeTest
//
//  Created by hech on 2023/11/24.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: BaseViewController  {
    private var autocompleteConfiguration: AutocompleteConfiguration?
    
    private let cameraLatitude: CLLocationDegrees = -0
    private let cameraLongitude: CLLocationDegrees = 0
    private let cameraZoom: Float = 14
    
    private var marker: GMSMarker?
    private var polyline : GMSPolyline?
    
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
    
    private var footBtn : UIButton!
    private var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
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
        footBtn = CommonButton.init(type: .custom)
        footBtn.setTitle("开始导航", for: .normal)
        footBtn.setTitle("到达目的", for: .selected)
        footBtn.addTarget(self, action: #selector(footClick(_:)), for: .touchUpInside)
        self.view.addSubview(footBtn)
        footBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
        }
        self.setNavBarRightImageName("search_icon")
    }
    
    // Locition search function
    override func rightButtonAction() {
        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.delegate = self
        if let config = autocompleteConfiguration {
            autocompleteViewController.autocompleteFilter = config.autocompleteFilter
            autocompleteViewController.placeFields = config.placeFields
        }
        navigationController?.present(autocompleteViewController, animated: true)
    }
    
    
    // 添加标记
    func addMarker(at coordinate: CLLocationCoordinate2D) {
        marker?.map = nil
        marker = GMSMarker()
        marker?.position = coordinate
        marker?.title = "Seacrh Location"
        marker?.map = mapView
    }
    
    func fitMarkers(coordinate: CLLocationCoordinate2D) {
        let update = GMSCameraUpdate.setTarget(coordinate, zoom: cameraZoom)
        mapView.animate(with: update)
    }
    
    func requestDistance(start : CLLocationCoordinate2D, end : CLLocationCoordinate2D) {
        Loading.show()
        DistanceCalculator.share.getDistance(from: "\(start.latitude),\(start.longitude)", to: "\(end.latitude),\(end.longitude)") {[weak self] model, error in
            Loading.dismiss()
            guard error == nil else {
                (error?.localizedDescription)?.showError()
                return
            }
            guard model != nil else {
                "data error".showError()
                return
            }
            
            dispatch_async_safely_main_queue {
                self?.drawPath(model: model)
                self?.fitMarkers(coordinate: start)
                self?.setNavigatingState()
            }
        }
    }
    
    @objc func footClick(_ btn: UIButton){
        if btn.isSelected {
            
        }else{
            self.startAction(btn)
        }
    }
    
    
    func startAction(_ btn: UIButton)  {
        guard let end = self.marker else {
            "请选择目的地".showWarnToast()
            return }
        guard let start = self.location else {
            "重新定位失败，正在重新定位".showWarnToast()
            Location.shared.didUpdateLocation(self)
            return }
        self.requestDistance(start: start.coordinate, end: end.position)
    }
    
    func setNavigatingState() {
        self.footBtn.isSelected = true
    }
    
    
    
    func drawPath(model : DirectionsModel?) {
        polyline?.map = nil
        let path = GMSMutablePath(fromEncodedPath: model?.routes?.first?.overview_polyline?.points ?? "")
        polyline = GMSPolyline(path: path)
        polyline?.strokeWidth = 3.0
        polyline?.strokeColor = ThemeColor
        polyline?.map = self.mapView
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
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if (self.footBtn.isSelected){
            return
        }
        addMarker(at: coordinate)
        fitMarkers(coordinate: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // 检查 myLocation 属性，如果为 nil，表示 GPS 信号丢失
        if mapView.myLocation == nil {
            "GPS信号丢失".showError()
        }
    }
}

//Google Place Delegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        navigationController?.dismiss(animated: true)
        self.addMarker(at: place.coordinate)
        self.fitMarkers(coordinate: place.coordinate)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        navigationController?.dismiss(animated: true)
        let errorStr = String(
            format: NSLocalizedString(
                "Demo.Content.Autocomplete.FailedErrorMessage",
                comment: "Format string for 'autocomplete failed with error' message"), error as NSError)
        errorStr.showError()
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController?.dismiss(animated: true)
    }
}

