//
//  PostCell.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 03/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var photoPost: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        photoPost.clipsToBounds = true
    }
    
    func configureCell(post: Post, img:UIImage?) {
        
        self.post = post
        self.postText.text = post.postDescription
        
        if post.imageUrl != nil
        {
            if img != nil
            {
                self.photoPost.image = img
            }
            else
            {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if ( err == nil )
                    {
                        let img = UIImage(data: data!)!
                        self.photoPost.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        }
        else
        {
            self.photoPost.hidden = true
        }
        
        
    }

}
