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
    private var userPolyline : GMSPolyline?
    private var tmpLocationArray = [CLLocationCoordinate2D]()
    
    
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
    
    private var footBtn : CommonButton!
    private var resetDistanceBtn : CommonButton!
    private var observation: NSKeyValueObservation?
    private var timer: DispatchSourceTimer?
    
    private var speedLabel : UILabel!
    private var timeLabel: UILabel!
    private var navigateMode : String = "walking"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTimer()
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
            guard let myLocation = mapView.myLocation else { return  }
            self?.location = myLocation
            NavigateService.share.addLocation(new: myLocation.coordinate)
            let speedValue = (self?.location?.speed ?? 0) < 0 ? 0 : (self?.location?.speed ?? 0)
            self?.speedLabel.text = String(format: "%.1f m/s", speedValue)
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
        
        resetDistanceBtn = CommonButton.init(type: .custom)
        resetDistanceBtn.setSubStyle(12, 14)
        resetDistanceBtn.isHidden = true
        resetDistanceBtn.setTitle("重新导航", for: .normal)
        resetDistanceBtn.addTarget(self, action: #selector(resetDistance(_:)), for: .touchUpInside)
        self.view.addSubview(resetDistanceBtn)
        resetDistanceBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.left.equalToSuperview().offset(10)
        }
        
        speedLabel = CommonLabel.init()
        self.view.addSubview(speedLabel)
        speedLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            make.right.equalTo(-20)
        }
        speedLabel.isHidden = true
        timeLabel = CommonLabel.init()
        self.view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(speedLabel.snp.bottom).offset(12)
            make.right.equalTo(-20)
        }
        timeLabel.isHidden = true
        
        self.setNavBarRightImageName("search_icon")
    }
    
    func setupTimer(){
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                let time = Date.timeStamp - NavigateService.share.startTime
                self?.timeLabel.text = String(format: "%ldm : %02lds \n %.0fm", time/60, time%60,NavigateService.share.totalDistance)
                self?.drawUserPath()
            }
        }
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
        let update = GMSCameraUpdate.setTarget(coordinate)
        mapView.animate(with: update)
    }
    
    func requestDistance(start : CLLocationCoordinate2D, end : CLLocationCoordinate2D) {
        Loading.show()
        DistanceCalculator.share.getDistance(from: "\(start.latitude),\(start.longitude)", to: "\(end.latitude),\(end.longitude)",mode: self.navigateMode) {[weak self] model, error in
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
                let legs = model?.routes?.first?.legs?.first
                let content = "本次导航全长\(legs?.distance?.text ?? ""),估计用时\(legs?.duration?.text ?? "")"
                AlertTool.alertTitle(title: "导航详情", content: content) {}
            }
        }
    }
    
    @objc func footClick(_ btn: UIButton){
        if btn.isSelected {
            AlertTool.alertTitle(title: "到达目的,结束导航？",content: nil) {[weak self] compelete in
                if compelete {
                    self?.endNavigatingState()
                }
            }
        }else{
            self.startAction()
        }
    }
    
    @objc func resetDistance(_ btn: UIButton){
        AlertTool.alertTitle(title: "您正在导航，是否重新计算路线？",content: nil) {[weak self] compelete in
            if compelete {
                self?.startAction()
            }
        }
    }
    
    func startAction()  {
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
        self.timeLabel.isHidden = false
        self.speedLabel.isHidden = false
        resetDistanceBtn.isHidden = false
        if NavigateService.share.status == .normal {
            timer?.resume()
        }
        NavigateService.share.startNavigate()
    }
    
    func endNavigatingState() {
        self.footBtn.isSelected = false
        self.timeLabel.isHidden = true
        self.speedLabel.isHidden = true
        resetDistanceBtn.isHidden = true
        NavigateService.share.endNavigate()
        timer?.suspend()
    }
    
    
    func drawPath(model : DirectionsModel?) {
        polyline?.map = nil
        let path = GMSMutablePath(fromEncodedPath: model?.routes?.first?.overview_polyline?.points ?? "")
        polyline = GMSPolyline(path: path)
        polyline?.strokeWidth = 3.0
        polyline?.strokeColor = ThemeColor
        polyline?.map = self.mapView
    }
    
    func drawUserPath() {
        if NavigateService.share.locationArray.count == self.tmpLocationArray.count {
            return
        }
        self.tmpLocationArray = NavigateService.share.locationArray
        userPolyline?.map = nil
        let path = NavigateService.share.path
        userPolyline = GMSPolyline(path: path)
        userPolyline?.strokeWidth = 3.0
        userPolyline?.strokeColor = .green
        userPolyline?.map = self.mapView
    }
    
    deinit {
        timer?.cancel()
        timer = nil
        observation?.invalidate()
    }
}

// Google Map Delegate
extension MapViewController: GMSMapViewDelegate {
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
        let errorStr = error.localizedDescription
        errorStr.showError()
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController?.dismiss(animated: true)
    }
}

