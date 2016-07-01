//
//  ComposeViewController.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/28/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tweetComposeView: UIView!
    @IBOutlet weak var composeLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetField: UITextField!
    
    @IBAction func onPost(sender: AnyObject) {
        
        print("post button is being pressed")
        
        TwitterClient.sharedInstance.tweet(tweetField.text!, params: nil) { (error) in
            self.dismissViewControllerAnimated(true, completion: nil)
            print(error?.localizedDescription)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetField.delegate = self
        
        tweetComposeView.layer.cornerRadius = 16
        composeLabel.layer.masksToBounds = true
        composeLabel.layer.cornerRadius = 10
        //borderView.layer.cornerRadius = 16
        //tweetComposeView.layer.borderColor = UIColor.darkGrayColor().CGColor
        //tweetComposeView.layer.borderWidth = 5.0
        /*
        let options: [FlickToDismissOption] = [
            .Animation(.Scale),
            .BackgroundColor(UIColor(white: 0.0, alpha: 0.8))
        ]
        
        let vc = FlickToDismissViewController(flickableView: tweetComposeView, options: options)
        vc.modalTransitionStyle = .CrossDissolve
        vc.modalPresentationStyle = .OverFullScreen
        presentViewController(vc, animated: true, completion: nil)
        */
        
        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text!.utf16.count) + string.utf16.count - range.length
        //change the value of the label
        let characterLimit = 140
        countLabel.text =  String(characterLimit - newLength)
        //you can save this value to a global var
        //myCounter = newLength
        //return true to allow the change, if you want to limit the number of characters in the text field use something like
        return newLength <= 139 // To just allow up to 140 characters
        return true
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


//extension FlickToDismissViewController {
    
//}
