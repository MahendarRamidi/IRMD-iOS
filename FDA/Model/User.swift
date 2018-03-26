//
//  User.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class User: NSObject {
    var email : String!
    var password : String!
    var UserID : String!
    var token : String!
    
    open func dictionaryRepresentation() -> [String : AnyObject] {
        var dictionary = [String: AnyObject]()
        if let email = email {
            dictionary["email"] = email as AnyObject?
        }
        
        if let password = password as AnyObject? {
            dictionary["password"] = password
        }
        
        if let UserID = UserID as AnyObject? {
            dictionary["UserID"] = UserID
        }
        
        if let token = token as AnyObject? {
            dictionary["token"] = token
        }
        
        return dictionary
    }
}
