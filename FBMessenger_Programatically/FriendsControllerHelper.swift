//
//  FriendsControllerHelper.swift
//  FBMessenger_Programatically
//
//  Created by Fernando Cardenas on 22/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
    func setupData(){
        
        clearData()
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            let mark = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
            createMessageWithText("Hello, my name is Mark. Nice to meet you.", friend: mark, minutesAgo: 2, context: context)
            
            let steve = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            steve.name = "Steve Jobs"
            steve.profileImageName = "steve_profile"
            
            createMessageWithText("Apple creates great iOS Devices for the world...", friend: steve, minutesAgo: 1, context: context)
            
            createMessageWithText("What product would you like to buy.", friend: steve, minutesAgo: 0, context: context)
            
            
            do {
                try(context.save())
            }catch let err {
                print(err)
            }
            
            //messages = [message, messageSteve]
        }
        
        loadData()
        
    }
    
    func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext){
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    let fetchRequest = NSFetchRequest(entityName: "Message")
                    
                    //We want to get only the last message
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetchedMessages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                        messages?.appendContentsOf(fetchedMessages!)
                    }catch let err {
                        print(err)
                    }
                }
            }
            
        }
    }
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                let entityNames = ["Message", "Friend"]
                
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    
                    let objects = try(context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.deleteObject(object)
                    }
                }
                
                
                
            }catch let err {
                print(err)
            }
            
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                let fetchRequest = NSFetchRequest(entityName: "Friend")
                return try context.executeFetchRequest(fetchRequest) as? [Friend]
                
                
            }catch let err {
                print(err)
            }
            
        }
        return nil

    }
}
