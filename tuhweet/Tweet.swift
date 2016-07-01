//
//  Tweet.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/26/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
  
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var username: String?
    var userDictionary: NSDictionary?
    var user: User?
    let id: NSNumber?
    var hasBeenFavorited: Bool?
    var hasBeenRetweeted: Bool?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favorite_count"] as? Int ?? 0
        hasBeenFavorited = dictionary["favorited"] as? Bool ?? false
        hasBeenRetweeted = dictionary["retweeted"] as? Bool ?? false
        id = dictionary["id"] as! NSNumber
        
        
        print(id)
        
        self.userDictionary = dictionary["user"] as? NSDictionary
        
        

        
        self.user = User(dictionary: userDictionary!)
        
        
//        print("HERE IS THE TWEETUSER YOU REQUESTED")
//        print(self.user!.followingCount)
//        print(self.user!.followersCount)
//        print(self.user!.tweetCount)
//        print("THIS IS THE END OF THE TWEETUSER INFORMATION")
        
        let timestampString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        if let timestampString = timestampString {
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    
    
    
}
