//
//  UserSettings.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//
import UIKit

class UserSettings: NSObject {
    static func saveLoggedInUser(user : User?){

        //Save settings to defaults
        if let user = user{
        UserDefaults.standard.set(user.dictionaryRepresentation(), forKey: "latestSettings")
        UserDefaults.standard.synchronize()
        }

    }
}
