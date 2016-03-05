//
//  PostCell.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 03/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    private var _post: Post?
    
    var post: Post? {
        return _post
    }
    
    var request: Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        appImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?) {
        
        //Clear existing image (because its old)
        self.appImg.image = nil
        self._post = post
        self.likeRef = DataServcie.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        if let desc = post.postDescription where post.postDescription != "" {
            self.descriptionText.text = desc
        }
        else {
            self.descriptionText.hidden = true
        }
        
       // self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            //Use the cached image if there is one, otherwise download the image
            if img != nil {
                appImg.image = img!
            } else {
                //Must store the request so we can cancel it later if this cell is now out of the users view
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.appImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post!.imageUrl!)
                    }
                })
            }
            
        }
        else {
            self.appImg.hidden = true
        }

    }
}