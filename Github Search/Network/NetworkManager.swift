//
//  NetworkManager.swift
//  Github Search
//
//  Created by Yermakov Anton on 2/25/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    
    var nextPage: String?
    
    func genericFetch(urlString: String, completion: @escaping([Repository]?, APIError?) -> ())  {
        
        AF.request(urlString, method: .get).validate(statusCode: 200..<300).response { response in
            guard response.error == nil else {
                completion(nil, APIError.requestFailed)
                return
            }
            if let httpResponse = response.response{
                self.nextPage = self.getNextPageFromHeaders(response: httpResponse)
            }
            guard let data = response.data else {
                completion(nil, APIError.invalidData)
                return
            }
            
            var repositories = [Repository]()
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                   guard let items = json["items"] as? [[String: Any]] else { return }
                    for item in items{
                        let repository = try Repository(item: item)
                        repositories.append(repository)
                    }
                }
                completion(repositories, nil)
            } catch {
                completion(nil, APIError.jsonParsingFailure)
            }
        }
    }
    

    private func getNextPageFromHeaders(response: HTTPURLResponse?) -> String? {

        guard let linkHeader = response?.allHeaderFields["Link"] as? String else { return nil }
        let links = linkHeader.components(separatedBy: ",")

        var dictionary: [String: String] = [:]
        links.forEach({
            let components = $0.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            dictionary[components[1]] = cleanPath
        })

        if let nextPagePath = dictionary["rel=\"next\""] {
            return nextPagePath
        }
        return nil
    }
    

} // class
