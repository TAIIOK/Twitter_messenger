//
//  ViewController.swift
//  TwitterLab
//
//  Created by Roman Efimov on 13.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import UIKit
import TwitterKit
import CoreData
import Foundation




var userID = ""
var friendsID = [String]()
var screen_name = [String]()
var name = [String]()
var my_screen_name = String()
var friendsImage = [String]()
var friendsPhoto = [UIImage]()
var MyPhoto = UIImage()
var DirectMessages : NSArray = NSArray()
var DirectMessagesSent : NSArray = NSArray()


var Timer: NSTimer!



class ViewController: UIViewController {
    
    @IBAction func logOut(sender: AnyObject) {
        
        let store = Twitter.sharedInstance().sessionStore
        
        store.logOutUserID(userID)
        userID = ""
        deleteCoredata()
        loginBut()
        
    }
    @IBAction func toDilog(sender: AnyObject) {
        
        let TableViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as? TableViewController
        self.navigationController?.pushViewController(TableViewControllerObejct!, animated: true)
        
    }
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserId()
        print("currentuser")
        print(userID)
        
        if(userID.isEmpty)
        {
            loginBut()
        }
        else
        {
            openTable()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func loginBut()
    {
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                
                self.saveUserId((session?.userID)!,name: (session?.userName)!)
                
                
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.openTable()
                
                
                for v in self.view.subviews{
                    if v is TWTRLogInButton{
                        v.removeFromSuperview()
                    }
                }
            }else
            {
                NSLog("Login error: %@", error!.localizedDescription);
            }
            
        }
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        
    }
    
    func openTable()
    {
        loadUserId()
   
        loadFriends()
        
        //loadDirectmessages()
        //loadDerictmessagesSent()
        getmyprofile()
       
        
    }
    func deleteCoredata() {
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        
        //let entity = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Person
        
        let personFetch = NSFetchRequest(entityName: "Person")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(personFetch) as! [Person]
            if(!fetchedPerson.isEmpty)
            {
                moc.deleteObject(fetchedPerson[0])
            }
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        friendsID.removeAll()
        screen_name.removeAll()
        name.removeAll()
        
        friendsImage.removeAll()
        friendsPhoto.removeAll()
        
        for(var i=0;DirectMessages.count<i;i++)
        {
            DirectMessages.delete(DirectMessages[i])
        }
        for(var i=0;DirectMessagesSent.count<i;i++)
        {
            DirectMessagesSent.delete(DirectMessagesSent[i])
        }
        
        
    }
    
    func saveUserId(UserID:String,name:String) {
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Person
        
        // add our data
        
        entity.setValue(UserID, forKey: "userID")
        entity.setValue(name, forKey: "name")
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func loadUserId(){
        
        
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "Person")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(personFetch) as! [Person]
            if(!fetchedPerson.isEmpty)
            {
                userID=(fetchedPerson.first?.userID)!
                my_screen_name=(fetchedPerson.first?.name)!
            }
            
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
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
    
    func getmyprofile()
    {
        
       
        
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
       
        
        let params = ["user_id" : userID , "screen_name" : my_screen_name]
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
                            print("Not a Dictionary \(JSON)")
                            
                          
                            // put in function
                            return
                            
                        }
                        for(key,value) in JSONDictionary
                        {
                            let keyName = key as! String
                            
                            if(keyName == "profile_image_url" )
                            {
                                
                                let twitterPhotoUrl = NSURL(string: value as! String)
                                let imageData = NSData(contentsOfURL: twitterPhotoUrl!)
                                let twitterImage: UIImage! = UIImage(data:imageData!)

                                MyPhoto = twitterImage
                            }
                        }
                        //print("JSONDictionary! \(JSONDictionary)")
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
    
    
    func postMessage(DialogUser: String,Text:String)
    {
        
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/direct_messages/new.json"
        
        let params = ["count": DialogUser,"text":Text]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
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
                            print("Not a Dictionary \(JSON)")
                            
                            
                            // put in function
                            return
                            
                        }
                        
                        print("JSONDictionary! \(JSONDictionary)")
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
    
    
    
    func loadFriends()
    {
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/friends/list.json"
        
        let params = ["cursor":"-1","screen_name":my_screen_name,"skip_status" : "false","include_user_entities":"false"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if (request != "")
        {
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                if (connectionError == nil) {
                    
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                        guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                           // print("Not a Dictionary \(JSON)")
                            // put in function
                            return
                        }
                        
                        for(key,value) in JSONDictionary
                        {
                            let keyName = key as! String
                            
                            
                            if(keyName == "users")
                            {
                                let keyValue:NSArray = value as! NSArray
                                for(var i=0;i<keyValue.count;i++)
                                {
                                    if let result = keyValue[i] as? NSDictionary
                                    {
                                        if let result_number = result.valueForKey("id") as? NSNumber
                                        {
                                            let result_string = "\(result_number)"
                                            
                                            
                                            friendsID.insert(result_string, atIndex: i)
                                            
                                        }
                                        
                                        let twitterPhotoUrl = NSURL(string: result.valueForKey("profile_image_url") as! String)
                                        let imageData = NSData(contentsOfURL: twitterPhotoUrl!)
                                        let twitterImage: UIImage! = UIImage(data:imageData!)
                                        friendsPhoto.insert(twitterImage,atIndex: i)
                                        friendsImage.insert(result.valueForKey("profile_image_url") as! String, atIndex: i)
                                        screen_name.insert(result.valueForKey("screen_name") as! String, atIndex: i)
                                        name.insert(result.valueForKey("name") as! String, atIndex: i)
                                    }
                                }
                                
                            }
                            if (self.respondsToSelector(NSSelectorFromString(keyName ))) {
                                
                            }
                            
                        }
                        
                     //   print("JSONDictionary! \(JSONDictionary)")
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    
                }
                else {
                    print("Error: \(connectionError)")
                }
            }
        }
        }
        else {
            print("Error: \(clientError)")
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

