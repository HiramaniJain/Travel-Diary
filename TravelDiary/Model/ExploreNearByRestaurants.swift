//
//  ExploreNearByRestaurants.swift
//  TravelDiary
//
//  Created by Heeral on 6/1/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import UIKit

class ExploreNearByRestaurants: UIViewController
{
    func exploreRestaurants(latitude:Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void)
    {
        let url = "https://api.foursquare.com/v2/venues/search?ll=\( latitude),\( longitude)&v=20190601&query=\(ClientNetwork().query)&limit=\(ClientNetwork().limit)&client_id=\(ClientNetwork().FourSquare_Client_ID)&client_secret=\(ClientNetwork().FourSquare_Client_Secret)"

        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print(request)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            
            print(String(data: data!, encoding: .utf8)!)
            if let data = data
            {
                let decoder = JSONDecoder()
                do {
                    let result = try? decoder.decode(FourSquare.self, from: data)
                    //cleaning restarants array
                    restaurants.removeAll()
                    if let venues = result?.response.venues {
                        for pin in venues {
                            let name = pin.name
                            let address = pin.location.address
                            let latitude = pin.location.lat
                            let longitude = pin.location.lng
                            let restaurant = Restaurant(name:name, address:address, latitude:latitude, longitude:longitude)
                            restaurants.append(restaurant)
                        }
                    }
                    
                    completion(true,nil)
                    
                }
            }
        }
        task.resume()
    }
}
