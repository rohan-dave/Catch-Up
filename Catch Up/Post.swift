//
//  Post.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 03/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class Post {
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _username: String!
    private var _postKey: String!
    private var _likes: Int!
    private var _postRef: Firebase!
    
    var postDescription: String! {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var username: String! {
        return _username
    }
    
    var postKey: String! {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String)
    {
        self._postDescription = description
        self._username = username
        self._imageUrl = imageUrl
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>)
    {
        self._postKey = postKey
        
        if let imgUrl = dictionary["imageUrl"] as? String
        {
            self._imageUrl = imgUrl
        }
        
        if let desc =  dictionary["description"] as? String
        {
            self._postDescription = desc
        }
        
        self._postRef = DataServcie.ds.REF_POSTS.childByAppendingPath(self._postKey)
    }
}