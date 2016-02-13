//
//  SentMessage.swift
//  TwitterLab
//
//  Created by Roman Efimov on 23.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Twitter
import TwitterKit

class SentMessage: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBAction func sent(sender: AnyObject) {
        
        postMessage(screen_name[currentuser], Text: textfield.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
   
    
    func postMessage(DialogUser: String,Text:String)
    {
        
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/direct_messages/new.json"
        
        let params = ["screen_name": screen_name[currentuser],"text":Text]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if (request != "")
        {
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
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
        else {
            print("Error: \(clientError)")
        }
        
        
    }

}
