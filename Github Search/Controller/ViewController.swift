//
//  ViewController.swift
//  Github Search
//
//  Created by Yermakov Anton on 2/25/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = "https://api.github.com/search/repositories?q=tetris&sort=stars&order=desc"
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         networkManager.genericFetch(urlString: url) { (repositories, error) in
            
             print(self.networkManager.nextPage)
            
            if let error = error{
                switch error{
                case .invalidData: self.onFetchFailed(with: "Invalid data")
                case .jsonParsingFailure: self.onFetchFailed(with: "JSON parsing failure")
                case .requestFailed: self.onFetchFailed(with: "Request failed")
                }
            }
            
            if let repo = repositories{
                // do somthing with data
            }
        }
        
    }
    
} // class


extension ViewController: AlertDisplayer{
    private func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

