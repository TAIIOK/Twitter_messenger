//
//  TableViewController.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import UIKit

var imageURL: UIImageView?
var imss:UIImage?
var currentuser = 0

class TableViewController: UITableViewController {
   
    var Friend = [Friends]()
    var imageView:UIImageView!
   // var imss:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        

    }
    func loadTable() {
        
        for(var i=0;i<name.count;i++)
        {
            
            let meal1 = Friends(name: name[i] ,photo: friendsPhoto[i], id: friendsID[i] )!
            Friend += [meal1]
           
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Friend.count
    }
     
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    
        let row = indexPath.row
        print("Row: \(row)")
        
        currentuser = row
       
        
        Chats.removeAll()
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as? ChatViewController
        
        self.navigationController?.pushViewController(secondViewController!, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TableViewCell

        let friend = Friend[indexPath.row]
        
        cell.zaim.text = friend.name
        cell.uim.image = friend.photo
        
        return cell
    }
    
}
