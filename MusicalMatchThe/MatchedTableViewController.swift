//
//  MatchedTableViewController.swift
//  MusicalMatchThe
//
//  Created by Joshua Kuehn on 5/10/15.
//  Copyright (c) 2015 Joshua Kuehn. All rights reserved.
//

import UIKit

class MatchedTableViewController: UITableViewController {
    
    var matches: [Match] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButton, animated: true)
        
        fetchMatches({
            matches in
            self.matches = matches
            self.tableView.reloadData()
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPreviousVC (button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return matches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userIdentifier", forIndexPath: indexPath) as UserTableViewCell

        // Configure the cell...
        let user = matches[indexPath.row].user
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image 
        })
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatViewController()
        let match = matches[indexPath.row]
        vc.matchID = match.id
        vc.title = match.user.name
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
