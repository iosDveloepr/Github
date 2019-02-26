//
//  GitHubTableViewCell.swift
//  Github Search
//
//  Created by Yermakov Anton on 2/26/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class GitHubTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryURL: UILabel!
    
    func setupCell(repo: Repository){
        self.repositoryName.text = repo.name
        self.repositoryURL.text = repo.url
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
