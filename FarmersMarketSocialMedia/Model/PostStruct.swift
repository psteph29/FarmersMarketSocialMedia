//
//  PostStruct.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/15/23.
//

import Foundation

struct Post: Identifiable {
    var id: String
    var description: String
    var date: Date
    var imageURL: String?
    
    var imageURLObject: URL? {
        guard let urlString = imageURL else {
            return nil
        }
        return URL(string: urlString)
    }
}
