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
            
            createMessageWithText("Good Morning.", friend: steve, minutesAgo: 1, context: context)
            
            createMessageWithText("Apple creates great iOS Devices for the world. I hope you are doing great.", friend: steve, minutesAgo: 1, context: context)
            
            createMessageWithText("What product would you like to buy. We have a wide range of Apple Devices that will suit your needs. Pleae make your purchase with us.", friend: steve, minutesAgo: 0, context: context)
            
            let donald = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_trump_profile"
            
            createMessageWithText("You're fired", friend: donald, minutesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            gandhi.name = "Gandhi"
            gandhi.profileImageName = "gandhi"
            
            createMessageWithText("Love, Peace and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            let hillary = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            createMessageWithText("Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)

            
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
                
                messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedDescending})
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
