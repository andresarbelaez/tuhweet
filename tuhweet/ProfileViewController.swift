//
//  ProfileViewController.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/27/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import MGSwipeTableCell
class ProfileViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var tweets = [Tweet]()
    
    var tweet: Tweet?
    
    var user: User?
    
    let redColor = UIColor(red: 1, green: 0.298, blue: 0.298, alpha: 1.0) /* #ff4c4c */
    let greenColor = UIColor(red: 0.4196, green: 1, blue: 0.5451, alpha: 1.0) /* #6bff8b */
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        //if tweet != nil {
        
        //}
        
        
        
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print(user?.screenname!)
        
        print("THIS IS WHAT THE USERNAME SHOULD BE")
        print(self.user?.screenname)
        if user == nil {
            user = User.currentUser
            print("CURRENT USERNAME SHOULD BE HERE")
            print(user?.screenname!)
        }
        loadData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        profilePictureView.layer.borderWidth = 3.0
        profilePictureView.layer.borderColor = UIColor.whiteColor().CGColor
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowOpacity = 1
        tableView.layer.shadowOffset = CGSizeZero
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).CGPath
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        loadData()
        refreshControl.endRefreshing()
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
        print(self.tweets.count)
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath:indexPath) as! TweetCell
        
        let tweet = self.tweets[indexPath.row]
        
        cell.tweet = tweet
        cell.loadCellData()
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named: "retweet.png"), backgroundColor: greenColor,callback: {(sender: MGSwipeTableCell!) -> Bool in
            cell.onRetweet(sender)
            return true
        })]
        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named: "favorite.png"), backgroundColor: redColor, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            cell.onFavorite(sender)
            return true
        })]
        cell.selectionStyle = .None
        return cell
    }
    
    
    func loadCurrentUserData(){
        TwitterClient.sharedInstance.currentAccount({ (user: User) in
            
            self.user = user
            
        }) { (error: NSError) in
                
        }
    }
    
    
    func loadData(){
        TwitterClient.sharedInstance.userAccount((self.user?.screenname)!, success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
            let tweetCountString = self.suffixNumber(self.user!.tweetCount)
            print(tweetCountString)
            let followingCountString = self.suffixNumber(self.user!.followingCount)
            print(tweetCountString)
            let followersCountString = self.suffixNumber(self.user!.followersCount)
            print(tweetCountString)
            
            let bannerUrl = self.user!.profileBannerUrl
            print(bannerUrl)
            
            let bannerRequest = NSURLRequest(URL: bannerUrl!)
            self.bannerView.setImageWithURLRequest(bannerRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                self.bannerView.image = image
                }, failure: { (imageRequest, imageResponse, error) in
                    print("HERE IS THE ERROR")
            })
            
            self.tweetCount.text = (tweetCountString as String)
            self.followingCount.text =  (followingCountString as String)
            self.followersCount.text = (followersCountString as String)
            
            let tagline = self.user?.tagline
            self.bioLabel.text = tagline
            let name = self.user?.name
            self.nameLabel.text = name
            
            let imageUrl = self.user!.profileUrl
            let imageRequest = NSURLRequest(URL: imageUrl!)
            self.profilePictureView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) in
                
                self.profilePictureView.image = image
                
                }, failure: { (imageRequest, imageResponse, error) in
                    
            })
            
            
 
        }) { (error: NSError) in
            
        }
    
    }
    
    func suffixNumber(number:NSNumber) -> NSString {
        
        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            let intNum = Int(num)
            return "\(sign)\(intNum)";
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
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
