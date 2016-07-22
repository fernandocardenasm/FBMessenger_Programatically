//
//  Message.swift
//  FBMessenger_Programatically
//
//  Created by Fernando Cardenas on 22/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var text: String?
    var date: NSDate?
    var friend: Friend?
    
}

class Friend {
    var name: String?
    var profileImageName: String?
}
