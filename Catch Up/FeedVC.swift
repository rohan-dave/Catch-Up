//
//  FeedVC.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 03/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    static let imageCache = NSCache()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 407
        postImg.layer.cornerRadius = 2.0
        postImg.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        initObservers()
    }
    
    func initObservers() {
        
        DataServcie.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                self.posts = []
                for snap in snapshots {
                    print("SNAP:\(snap)")
                    
                    //Clear the array because we are going to add all the objects again
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
                
                self.tableView.reloadData()
            }
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            //Cancel the image request when cellForRowAtIndexPath is called because it means
            //we need to recycle the cell and we need the old request to stop downloading the image
            cell.request?.cancel()
            
            let post = self.posts[indexPath.row]
            
            //Declare an empty image variable
            var img: UIImage?
            
            //If there is a url for an image, try and get it from the local cache first
            //before we attempt to download it
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
            
        } else {
            
            return PostCell()
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = self.posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    @IBAction func selectPhoto(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postField.text where txt != "" {
            
            if let img = postImg.image {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                
                let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name:"fileupload", fileName:"image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }) { encodingResult in
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON(completionHandler: { request, response, result in
                                if let info = result.value as? Dictionary<String, AnyObject> {
                                    
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        print(links)
                                        if let imgLink = links["image_link"] as? String {
                                            self.postToFirebase(imgLink)
                                        }
                                    }
                                }
                            })
                            
                        case .Failure(let error):
                            print(error)
                            //Maybe show alert to user and let them try again
                        }
                }
            } else {
                postToFirebase(nil)
            }
            
            
        }
        
    }
    
    func postToFirebase(imgUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = [
            "description":postField.text!,
            "likes": 0
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        //Save new post to firebase
        let fbPost = DataServcie.ds.REF_POSTS.childByAutoId()
        fbPost.setValue(post)
        
        //Clear out fields
        self.postField.text = ""
        self.postImg.image = UIImage(named: "camera")
        
        tableView.reloadData()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        postImg.image = image
    }
}
