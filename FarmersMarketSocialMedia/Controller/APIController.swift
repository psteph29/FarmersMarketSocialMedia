//
//  APIController.swift
//  FarmersMarketSocialMedia
//
//  Created by Paige Stephenson on 9/6/23.
//

import Foundation
import UIKit

class APIController {
    
    enum FetchFarmDataError: Error, LocalizedError {
        case farmNotFound
    }
    
    var baseURL = URL(string:"https://www.usdalocalfoodportal.com/api/farmersmarket/")!
    let apiKey = "0oIrzX0VFY"
    
    func fetchFarms(zip: String?, radius: Int?) async throws -> [Farm] {

        var urlComps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        

        var queryItems: [URLQueryItem] = [URLQueryItem(name: "apikey", value: apiKey)]
        
//        if let state = state {
//            queryItems.append(URLQueryItem(name: "state", value: state))
//        }

        if let zip = zip {
            queryItems.append(URLQueryItem(name: "zip", value: zip))
        }
        
        if let radius = radius {
            queryItems.append(URLQueryItem(name: "radius", value: "\(radius)"))
        }
        
        // Assign query items
        urlComps.queryItems = queryItems
        
        print("URL: \(String(describing: urlComps.url))") // Debugging URL
        
        // Perform network call
        let (data, response) = try await URLSession.shared.data(from: urlComps.url!)
        print(String(data: data, encoding: .utf8) ?? "Data could not be printed")
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FetchFarmDataError.farmNotFound
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        return searchResponse.data
    }
    
}
