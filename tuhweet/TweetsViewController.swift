//
//  TweetsViewController.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/26/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import RZTransitions
import BubbleTransition
import HidingNavigationBar
import MGSwipeTableCell
class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var tweets = [Tweet]()
    let transition = BubbleTransition()
    let redColor = UIColor(red: 1, green: 0.298, blue: 0.298, alpha: 1.0) /* #ff4c4c */
    let greenColor = UIColor(red: 0.4196, green: 1, blue: 0.5451, alpha: 1.0) /* #6bff8b */

    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBAction func onLogout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var hidingNavBarManager: HidingNavigationBarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        if let tabBar = navigationController?.tabBarController?.tabBar {
            hidingNavBarManager?.manageBottomBar(tabBar)
        }
        
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomPushAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        loadData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        hidingNavBarManager?.refreshControl = refreshControl
        
        let twitterBlue = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        navigationController?.navigationBar.barTintColor = twitterBlue
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tabBarController?.tabBar.barTintColor = twitterBlue
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    //// TableView datasoure and delegate
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // TODO: Perform the animation
        self.performSegueWithIdentifier("composeSegue", sender: nil)
    }
    /*
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    */
    
    
    
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            self.tweets = tweets
            
            for tweet in tweets {
                //print("\(tweet.text!)")
            }
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath:indexPath) as! TweetCell
        
        let tweet = self.tweets[indexPath.row]
        
        cell.tweet = tweet
        cell.loadCellData()
        cell.retweetButton.tag = indexPath.row
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named: "retweet.png"), backgroundColor: greenColor,callback: {(sender: MGSwipeTableCell!) -> Bool in
            cell.onRetweet(sender)
            return true
        })]
        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named: "reply.png"), backgroundColor: UIColor.whiteColor()), MGSwipeButton(title: "", icon: UIImage(named: "favorite.png"), backgroundColor: redColor, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            cell.onFavorite(sender)
            return true
        })]
        cell.selectionStyle = .None
        return cell
    }
    
    func loadData(){
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            
            self.tweets = tweets
            self.tableView.reloadData()
            
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //self.transitioningDelegate = RZTransitionsManager.shared()
        
        
        if segue.identifier == "detailSegue" {
            let vc = segue.destinationViewController as! DetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            
            let tweet = tweets[indexPath!.row]
            vc.tweet = tweet
            
            print(tweet)
            
            print(vc.tweet)
            
        } else if segue.identifier == "profileSegue" {
            let vc = segue.destinationViewController as! ProfileViewController
            let button = sender as! UIButton
            let tweet = tweets[button.tag]
            
            vc.transitioningDelegate = RZTransitionsManager.shared()
            
            //self.presentViewController(vc, animated: true, completion: nil)
            
            let userToBeShown = tweet.user
            vc.user = userToBeShown
            
        } else if segue.identifier == "composeSegue" {
            let vc = segue.destinationViewController as! ComposeViewController

            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .Custom
            
            
            //self.presentViewController(vc, animated: true, completion: nil)
            
            
        } else {
            
        }

    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        
        transition.startingPoint = CGPoint(x: 290.0, y: 55.0)
        //transition.startingPoint = (composeButton.accessibilityActivationPoint)
        transition.bubbleColor = (composeButton.tintColor)!
    
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        //transition.startingPoint = (composeButton.accessibilityActivationPoint)
        
        transition.startingPoint = CGPoint(x: 290.0, y: 55.0)
        
        //transition.bubbleColor = (composeButton.tintColor)!
        transition.bubbleColor = UIColor.whiteColor()
        return transition
    }


}
