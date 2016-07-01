//
//  DetailViewController.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/27/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    var tweets = [Tweet]()
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tweet)
        
        loadData()
        
    }
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite((tweet?.id)!, params: nil) { (error) in
            var fcount = self.tweet?.favoriteCount
            fcount = fcount! + 1
            self.favoriteLabel.text = "\(fcount!)"
        }
    }
    
    
    @IBOutlet weak var RTButton: UIButton!
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet((tweet?.id)!, params: nil) { (error) in
            var rCount = self.tweet?.retweetCount
            rCount = rCount! + 1
            self.retweetLabel.text = "\(rCount!)"
        }
    }
    
    func loadData(){
        print("++++++++++++++++++++++++++++++++++++++")
        print(tweet?.text)
        print(tweet?.user?.screenname)
        print("++++++++++++++++++++++++++++++++++++++")
        
        if let screenname = tweet?.user?.screenname {
            usernameLabel.text = "@\(screenname)"
        }
        
        if let name = tweet?.user?.name {
            nameLabel.text = name
        }
        
        if (tweet?.hasBeenRetweeted)! == true {
            self.RTButton.imageView!.image = UIImage(named: "retweetOn")
            
        } else {
            self.RTButton.imageView!.image = UIImage(named: "retweet")
        }
        
        
        tweetLabel.text = tweet?.text
        
        let timestamp = tweet?.timestamp
        
        timestampLabel.text = "\(timestamp!.dateTimeUntilNow()!)"
        
        let rtCount = tweet?.retweetCount
        
        retweetLabel.text = "\(rtCount!)"
        
        let fCount = tweet?.favoriteCount
        
        favoriteLabel.text = "\(fCount!)"
        if (tweet?.hasBeenFavorited)! == true {
            self.favoriteButton.imageView!.image = UIImage(named: "favoriteOn")
            print("this one has been favorited")
        } else {
            self.favoriteButton.imageView!.image = UIImage(named: "favorite")
            print("this one has not been favorited")
        }
        
        
        let imageUrl = tweet?.user?.profileUrl
        
        let imageRequest = NSURLRequest(URL: imageUrl!)
        profilePictureView.layer.cornerRadius = 10
        
        profilePictureView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
            
            if imageResponse != nil {
                self.profilePictureView.alpha = 0.0
                self.profilePictureView.image = image
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.profilePictureView.alpha = 1.0
                })
            } else {
                self.profilePictureView.image = image
            }
        }) { (imageRequest, imageResponse, error) in
        }
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
