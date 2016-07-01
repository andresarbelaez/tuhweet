//
//  TweetCell.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/27/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import MGSwipeTableCell

class TweetCell: MGSwipeTableCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!

    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var RTButton: UIButton!
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        print("at least we know the fav button was pressed")
        print(tweet?.id)
        TwitterClient.sharedInstance.favorite((tweet?.id)!, params: nil) { (error) in
            print("Im pretty sure that was favorited!")
            
            var fcount = self.tweet?.favoriteCount
            fcount = fcount! + 1
            self.favoriteLabel.text = "\(fcount!)"
            self.favoriteButton.imageView!.image = UIImage(named: "favoriteOn")
            
            var isFavorited = self.tweet?.hasBeenFavorited
            isFavorited = true
            
            
        }
        
        
        
        
    }
    @IBOutlet weak var retweetButton: UIButton!
    @IBAction func onRetweet(sender: AnyObject) {
        print("at least we know this button is being pressed")
        print(tweet?.id)
        TwitterClient.sharedInstance.retweet((tweet?.id)!, params: nil, completion: { (error) -> () in
            print("that jawn has been retweeted")
        })
        var rCount = self.tweet?.retweetCount
        rCount = rCount! + 1
        self.RTButton.imageView!.image = UIImage(named: "retweetOn")
        self.retweetLabel.text = "\(rCount!)"
        
    }
    var tweet: Tweet?
    
    
    func loadCellData(){
        usernameLabel.text = tweet?.user?.name
        
        screennameLabel.text = "@\((tweet?.user?.screenname)!)"
        
        tweetLabel.text = tweet?.text
        
        let date = tweet?.timestamp
        
        timestampLabel.text = "\(date!.dateTimeUntilNow()!)"
        
        let rtCount = tweet?.retweetCount
        
        
        
        retweetLabel.text = "\(rtCount!)"
        
        let fCount = tweet?.favoriteCount
        
        
        if ((self.tweet?.hasBeenFavorited)! == true){
            self.favoriteButton.imageView!.image = UIImage(named: "favoriteOn")
        } else {
            self.favoriteButton.imageView!.image = UIImage(named: "favorite")
        }
        
        if ((self.tweet?.hasBeenRetweeted)! == true) {
            self.RTButton.imageView!.image = UIImage(named: "retweetOn")
        } else {
            self.RTButton.imageView!.image = UIImage(named: "retweet")
        }
        
        
        
        favoriteLabel.text = "\(fCount!)"
        
        let imageUrl = tweet?.user?.profileUrl
        
        let imageRequest = NSURLRequest(URL: imageUrl!)
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if tweet != nil {
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
