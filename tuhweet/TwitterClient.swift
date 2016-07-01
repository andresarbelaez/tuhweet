//
//  TwitterClient.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/26/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {

    
    static let sharedInstance = TwitterClient(baseURL:
    NSURL(string: "https://api.twitter.com")!, consumerKey:
    "QUjag1j8DjFl66y2PizTqVCQh", consumerSecret: "nCnPgm3nGxJjx1Vq8oaTBX1Z9GvwnqMANCPqLoy7zd33p7xFNb")
    
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: () -> (), failure: (NSError) ->  ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytuhweet://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath(
            "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
                print("I got the access token!!!")
                
                
                self.currentAccount({ (user: User) in
                    User.currentUser = user
                    self.loginSuccess?()
                    
                    }, failure: { (error: NSError) in
                        self.loginFailure?(error)
                })
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription  )")
            self.loginFailure?(error)
        }
    }
    
    func tweet(status: String, params: NSDictionary?, completion: (error: NSError?) -> ()) {
        
        let params = ["status" : status]
        
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("post has been tweeted")
            completion(error: nil)
            
            
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        
        
    }
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError)-> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //print("\(response)")
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
                print("error: \(error.localizedDescription)")
        })
        
    }
    
    
    func userAccount(screenname: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    
    func userAccount(screenname: String, completion: ([Tweet]) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //print("\(response)")
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            print("THESE ARE WHAT THE USER ACCOUNT TWEETS SHOULD BE")
            for tweet in tweets {
                //print(tweet.text)
            }
            
            completion(tweets)
            
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error.localizedDescription)")
        }
    }
    
    func retweet(id: NSNumber, params: NSDictionary?, completion: (error: NSError?) -> ()){
        
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("post has been retweeted")
            completion(error:nil)
            
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            
            print("error: \(error.localizedDescription)")
            
        }
    }
    
    
    func unretweet(id: String, params:NSDictionary?, completion: (error: NSError?) -> ()) {
        
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("post has been unretweeted")
            completion(error:nil)
            
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            
            print("error: \(error.localizedDescription)")
            
        }
        
        
        
    }
    
    func favorite(id: NSNumber, params: NSDictionary?, completion: (error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("post has been favorited")
            completion(error:nil)
            
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            
            print("error: \(error.localizedDescription)")
            
        }
        
        
        
        
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    
}
