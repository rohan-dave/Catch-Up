//
//  DataService.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 03/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import Firebase
import Foundation

let URL_BASE = "https://catch-up.firebaseio.com"

class DataServcie {
    
    static let ds = DataServcie()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    func createUser(uid: String, user: Dictionary<String,String>) {
        
        REF_USERS.childByAppendingPath(uid).setValue(user)
        
    }
}