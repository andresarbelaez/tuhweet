//
//  LoginViewController.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/25/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(sender: AnyObject) {
        
        let client = TwitterClient.sharedInstance
        
        client.login({ 
            
            print("I've logged in")
            
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
