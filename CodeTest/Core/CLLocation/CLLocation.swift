//
//  Location.swift
//  AngelDoctor
//
//  Created by dsq on 2021/4/22.
//

import UIKit
import CoreLocation

@objc public protocol LocationProtocol {
    //得到经纬度
    @objc optional func locationManager(latitude: Double, longitude: Double)

    //获取城市信息
    @objc optional func locationCityInfo(cityName: String)
    
    /// 定位城市失败
    @objc optional func locationCityFail()

}

class Location: NSObject {

    public weak var delegate: LocationProtocol?
    
    public static let shared = Location.init()
        
    private var locationManager: CLLocationManager?
    
    
    public func didUpdateLocation(_ vc: UIViewController){
    
        self.delegate = vc as? LocationProtocol
       
        self.requestLocationService()
        
    }
    
    //初始化定位
    private func requestLocationService(){
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
        }
        
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == .denied {
            //定位服务未开启
            self.alert()
        }else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            //未知错误
            locationManager?.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            let distance: CLLocationDistance = 100
            locationManager?.distanceFilter = distance
            locationManager?.startUpdatingLocation()
        }
    }
    
    //获取定位代理返回状态进行处理
    private func reportLocationServicesAuthorizationStatus(status: CLAuthorizationStatus) {
        if status == .notDetermined {
            //未知，继续请求授权
            requestLocationService()
        }else if(status == .restricted || status == .denied){
            //受限制,提示授权
//            self.alert()
            
            guard let delegate = self.delegate else { return }
            delegate.locationCityFail?()
        }else {
            //重新请求
            requestLocationService()
        }
    }

    private func alert(){
//        AlertTool.alertTitle(title: "定位权限未开启", content: "请在设置中开启天使医生定位权限", textAlignment: .center, leftTitle: "暂不", rightTitle: "去设置") { (result) in
//            if result {
//                let url = NSURL.init(string: UIApplication.openSettingsURLString)!
//                if UIApplication.shared.canOpenURL(url as URL) {
//                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//                }
//            }
//        }
    }
}


extension Location: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //停止定位
        self.locationManager?.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation.init()
        let coordinate = location.coordinate
        
        let latitude: Double = coordinate.latitude
        let longitude: Double = coordinate.longitude
        
        delegate?.locationManager?(latitude: latitude, longitude: longitude)
        
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(location) { (placemarkList, error) in
            guard let placemarkList = placemarkList else { return }
            if placemarkList.count > 0 {
                guard let placemark = placemarkList.first else { return  }
                var city = placemark.locality
                if city == nil {
                    city = placemark.administrativeArea
                }
               
                
                guard let delegate = self.delegate else { return }
                delegate.locationCityInfo?(cityName: city ?? "")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("权限改变")
        reportLocationServicesAuthorizationStatus(status: status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("定位失败")
        guard let delegate = self.delegate else { return }
        delegate.locationCityFail?()
        self.locationManager?.stopUpdatingLocation()
    }
}
