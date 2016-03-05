//
//  ViewController.swift
//  Catch Up
//
//  Created by ROHAN DAVE on 02/03/16.
//  Copyright © 2016 ROHAN DAVE. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func
        
    viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //If the user is already logged in take them straight to the next screen
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil {
            self.performSegueWithIdentifier("loginComplete", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wrongTextError (title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
        
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        if let email = email.text where email != "", let pwd = password.text where pwd != ""
        {
            DataServcie.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil
                {
                    if (error.code == -8)
                    {
                        DataServcie.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil
                            {
                                // There was an error creating the account
                                
                                self.wrongTextError("Could not create account!", msg: "Please try again with a valid email-id.")
                            }
                            else
                            {
                                NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")

                                
                                DataServcie.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {err, authData in
                                    
                                    let user = ["provider":authData.provider!, "blah":"test"]
                                    DataServcie.ds.createUser(authData.uid, user: user)
                                })
                                
                                self.performSegueWithIdentifier("loginComplete", sender: nil)
                                
                            }
                        })
                    }
                    
                    else
                    {
                        self.wrongTextError("Could not login.", msg: "Please check your username or password.")
                    }
                }
                else
                {
                    // We are now logged in
                    
                    DataServcie.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)            
                    
                self.performSegueWithIdentifier("loginComplete", sender: nil)
                    
                }
            })
            
        }
        else
        {
            wrongTextError("Email and Password required.", msg: "You must enter your email and password correctly.")
        }
        
    }

}

