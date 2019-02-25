//
//  Repository.swift
//  Github Search
//
//  Created by Yermakov Anton on 2/25/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import Foundation

enum SerializationError : Error {
    case missing(String)
}

struct Repository{
    let id: Int
    let name: String
    let url: String
    
    init (item: [String: Any]) throws {
        guard let id = item["id"] as? Int else { throw SerializationError.missing("The id is missing") }
        guard let name = item["name"] as? String else { throw SerializationError.missing("The name is missing") }
        guard let url = item["url"] as? String else { throw SerializationError.missing("The url is missing") }
        
        self.id = id
        self.name = name
        self.url = url
    }
}


