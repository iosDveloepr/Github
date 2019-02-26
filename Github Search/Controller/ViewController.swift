//
//  ViewController.swift
//  Github Search
//
//  Created by Yermakov Anton on 2/25/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = "https://api.github.com/search/repositories?q=tetris&sort=stars&order=desc"
    let networkManager = NetworkManager()
    var repositories = [Repository]()
    let cellIdentifier = "githubCell"
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         networkManager.genericFetch(urlString: url) { (repositories, error) in
            
            
            if let error = error{
                switch error{
                case .invalidData: self.onFetchFailed(with: "Invalid data")
                case .jsonParsingFailure: self.onFetchFailed(with: "JSON parsing failure")
                case .requestFailed: self.onFetchFailed(with: "Request failed")
                }
            }
            
            if let repo = repositories{
                self.repositories = repo
                self.tableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        print("offset \(offsetY), contentHeight \(contentHeight)")
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        guard let nextPage = networkManager.nextPage else { return }
        networkManager.genericFetch(urlString: nextPage) { (repositories, error) in
            if let error = error{
                switch error{
                case .invalidData: self.onFetchFailed(with: "Invalid data")
                case .jsonParsingFailure: self.onFetchFailed(with: "JSON parsing failure")
                case .requestFailed: self.onFetchFailed(with: "Request failed")
                }
            }
            
            if let repo = repositories{
                self.repositories.append(contentsOf: repo)
                self.fetchingMore = false
                self.tableView.reloadData()
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

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GitHubTableViewCell
        let repository = repositories[indexPath.row]
        cell.setupCell(repo: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

