//
//  ChatViewController.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import UIKit
import Twitter
import TwitterKit

var Chats = [Chat]()


var recv : NSMutableArray = NSMutableArray()
var sent : NSMutableArray = NSMutableArray()

class ChatViewController: UITableViewController {
    

    @IBAction func tosent(sender: AnyObject) {
        let TableViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("SentMessage") as? SentMessage
        self.navigationController?.pushViewController(TableViewControllerObejct!, animated: true)
        
    }

    var yourTextView : UITextView!

    
    override func viewDidLoad() {
    
        super.viewDidLoad()
       
     refresh()
    // addToolBar(yourTextView)
       // loadChat()
        
        //self.refreshControl = UIRefreshControl()
        //self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl!.addTarget(self, action: "refreshpull:", forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(refreshControl!)
        var timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "refresh", userInfo: nil, repeats: true)

    }
    
    func refreshpull(sender:AnyObject)
    {
        update()
   
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
        //self.refreshControl!.endRefreshing()

    }
    func refresh()
    {
        update()

        
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    
    }
    
    func update()
    {
        for(var i=0;DirectMessages.count<i;i++)
        {
            DirectMessages.delete(DirectMessages[i])
        }
        for(var i=0;DirectMessagesSent.count<i;i++)
        {
            DirectMessagesSent.delete(DirectMessagesSent[i])
        }
        
        loadDirectmessages()
        loadDerictmessagesSent()
        loadChat()
    }
    
    func loadDirectmessages()
    {
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/direct_messages.json"
        
        let params = ["count":"20","skip_status":"true"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if (request != "")
        {
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                if (connectionError == nil)
                {
                    
                    do
                    {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                        guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else
                        {
                            // print("Not a Dictionary \(JSON)")
                            
                            DirectMessages = JSON as! NSArray
                            
                            
                            // put in function
                            return
                            
                        }
                        
                        // print("JSONDictionary! \(JSONDictionary)")
                    }
                    catch let JSONError as NSError
                    {
                        print("\(JSONError)")
                    }
                    
                }
                else
                {
                    print("Error: \(connectionError)")
                }
            }
            
            
        }
        }
        else {
            print("Error: \(clientError)")
        }
        
    }

    
    func loadDerictmessagesSent()
    {
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/direct_messages/sent.json"
        
        let params = ["count":"20"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if (request != "")
        {
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                if (connectionError == nil)
                {
                    
                    do
                    {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                        guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else
                        {
                            // print("Not a Dictionary \(JSON)")
                            
                            DirectMessagesSent = JSON as! NSArray
                            
                            
                            // put in function
                            return
                            
                        }
                        
                        // print("JSONDictionary! \(JSONDictionary)")
                    }
                    catch let JSONError as NSError
                    {
                        print("\(JSONError)")
                    }
                    
                }
                else
                {
                    print("Error: \(connectionError)")
                }
            }
            
            
        }
        }
        else {
            print("Error: \(clientError)")
        }
        
        
    }

    func loadChat() {
        
        Chats.removeAll()
        recv.removeAllObjects()
        sent.removeAllObjects()
        
    
        var index = 0
        
        for(var i = 0;DirectMessages.count>i;i++)
        {
           
            if let result_number = DirectMessages.objectAtIndex(i).valueForKey("sender_id") as? NSNumber
            {
                let result_string = "\(result_number)"
            
            
            if ( result_string == friendsID[currentuser])
            {
                
                recv.insertObject(DirectMessages.objectAtIndex(i), atIndex: index)
             //DirectMessages.delete(DirectMessages.objectAtIndex(i))
               index++
            }
             
            }
            
        }
            index=0
    
            
        for(var i = 0;DirectMessagesSent.count>i;i++)
        {
            
            if let result_number = DirectMessagesSent.objectAtIndex(i).valueForKey("recipient_id") as? NSNumber
            {
                let result_string = "\(result_number)"
                
                
                if ( result_string == friendsID[currentuser])
                {
                    
                    sent.insertObject(DirectMessagesSent.objectAtIndex(i), atIndex: index)
                    index++
                   
                }
                
            }
        }
        var indexrecv=0
        var indexsent=0
     
        
    while(recv.count>indexrecv && sent.count>indexsent)
    {
     
         let result_number1 = (sent.count-indexsent-1)
        
         let result_number2 = (recv.count-indexrecv-1)
        
   
        
     let str1 = sent.objectAtIndex(result_number1).valueForKey("id") as? NSNumber
    
     let str2 = recv.objectAtIndex(result_number2).valueForKey("id") as? NSNumber
        
        let result_string1 = "\(str1)"
        let result_string2 = "\(str2)"
        
        if( result_string1 > result_string2)
        {
           
            let meal1 = Chat(name: recv.objectAtIndex(result_number2).valueForKey("text") as! String ,photoin: friendsPhoto[currentuser], photoout: nil )!
            
            Chats += [meal1]
            
            indexrecv++
        }
        else
        {
            
            let meal1 = Chat(name: sent.objectAtIndex(result_number1).valueForKey("text") as! String ,photoin: nil , photoout: MyPhoto  )!
            
            Chats += [meal1]
            indexsent++
        }
        
        
    }
    
        while(sent.count>indexsent)
        {
         
            let meal1 = Chat(name: sent.objectAtIndex(sent.count-indexsent-1).valueForKey("text") as! String ,photoin: nil , photoout: MyPhoto  )!
            
            Chats += [meal1]
            indexsent++
        }
        
        while(recv.count>indexrecv)
        {
            let meal1 = Chat(name: recv.objectAtIndex(recv.count-indexrecv-1).valueForKey("text") as! String ,photoin: friendsPhoto[currentuser], photoout: nil )!
            
            Chats += [meal1]
            
            indexrecv++
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
      //  self.navigationController?.setToolbarHidden(false, animated: animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        //self.navigationController?.setToolbarHidden(true, animated: animated)
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
        return Chats.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "ChatViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatViewCell
        
        let chat = Chats[indexPath.row]
        
    
        cell.friendimage.image = chat.photoin
        cell.label.text = chat.message
        cell.myimage.image = chat.photoout
       
      
        
        return cell
    }
    
}
