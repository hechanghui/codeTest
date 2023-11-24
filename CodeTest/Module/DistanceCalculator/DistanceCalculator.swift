//
//  DistanceCalculator.swift
//  CodeTest
//
//  Created by hech on 2023/11/24.
//

import Foundation
import HandyJSON
class DistanceCalculator {

    static let share = DistanceCalculator()

    
    ///  get Distance
    /// - Parameters:
    ///   - origin: The starting position: address or latitude and longitude
    ///   - destination: The end position: address or latitude and longitude
    ///   - model: have "driving","walking","bicycling" "transit"
    func getDistance(from origin: String, to destination: String, mode : String = "walking", completion: @escaping (DirectionsModel?, Error?) -> Void) {
        let apiKey = GoogleSDKKey.apiKey
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)&mode=\(mode)"

        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                let model = DirectionsModel.deserialize(from: json)
                completion(model, nil)

               
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
}
